//
//  NetworkManager.swift
//  Disability Advocacy iOS
//
//  Networking layer for API integration with URLSession
//

import Foundation

/// Network manager for handling API requests with error handling and retry logic
actor NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    // Configuration
    var baseURL: String = "https://api.disabilityadvocacy.app" // Placeholder - update with actual API
    var timeoutInterval: TimeInterval = 30
    var maxRetryAttempts: Int = 3
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024, diskPath: nil)
        
        self.session = URLSession(configuration: configuration)
        
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        self.encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - Configuration (safe mutation from outside the actor)

    func setBaseURL(_ baseURL: String) {
        self.baseURL = baseURL
    }

    func setTimeoutInterval(_ timeout: TimeInterval) {
        self.timeoutInterval = timeout
    }

    func setMaxRetryAttempts(_ attempts: Int) {
        self.maxRetryAttempts = attempts
    }
    
    // MARK: - Generic Request Method
    
    /// Performs a network request with automatic retry logic
    /// - Parameters:
    ///   - endpoint: The API endpoint path
    ///   - method: HTTP method (default: .GET)
    ///   - body: Optional request body data
    ///   - headers: Additional HTTP headers
    /// - Returns: The decoded response data
    func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .GET,
        body: Encodable? = nil,
        headers: [String: String] = [:]
    ) async throws -> T {
        var attempts = 0
        var lastError: Error?
        
        while attempts < maxRetryAttempts {
            do {
                let data = try await performRequest(
                    endpoint: endpoint,
                    method: method,
                    body: body,
                    headers: headers
                )
                
                return try decoder.decode(T.self, from: data)
            } catch {
                lastError = error
                attempts += 1
                
                // Don't retry on client errors (4xx)
                if let networkError = error as? NetworkError,
                   case .clientError = networkError {
                    throw error
                }
                
                // Wait before retry (exponential backoff)
                if attempts < maxRetryAttempts {
                    let delay = pow(2.0, Double(attempts)) // 2, 4, 8 seconds
                    try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? NetworkError.unknown
    }
    
    // MARK: - Private Request Implementation
    
    private func performRequest(
        endpoint: String,
        method: HTTPMethod,
        body: Encodable?,
        headers: [String: String]
    ) async throws -> Data {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.timeoutInterval = timeoutInterval
        
        // Set default headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // Add custom headers
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Add request body if provided
        if let body = body {
            do {
                request.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.encodingFailed(error)
            }
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            // Check status code
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 400...499:
                throw NetworkError.clientError(statusCode: httpResponse.statusCode, data: data)
            case 500...599:
                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
            default:
                throw NetworkError.unexpectedStatusCode(httpResponse.statusCode)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
    
    // MARK: - Convenience Methods
    
    /// GET request
    func get<T: Decodable>(endpoint: String, headers: [String: String] = [:]) async throws -> T {
        try await request(endpoint: endpoint, method: .GET, headers: headers)
    }
    
    /// POST request
    func post<T: Decodable>(endpoint: String, body: Encodable?, headers: [String: String] = [:]) async throws -> T {
        try await request(endpoint: endpoint, method: .POST, body: body, headers: headers)
    }
    
    /// PUT request
    func put<T: Decodable>(endpoint: String, body: Encodable?, headers: [String: String] = [:]) async throws -> T {
        try await request(endpoint: endpoint, method: .PUT, body: body, headers: headers)
    }
    
    /// DELETE request
    func delete<T: Decodable>(endpoint: String, headers: [String: String] = [:]) async throws -> T {
        try await request(endpoint: endpoint, method: .DELETE, headers: headers)
    }
}

// MARK: - HTTP Method

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
    case PATCH = "PATCH"
}

// MARK: - Network Error

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case encodingFailed(Error)
    case decodingFailed(Error)
    case clientError(statusCode: Int, data: Data?)
    case serverError(statusCode: Int)
    case unexpectedStatusCode(Int)
    case requestFailed(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .encodingFailed(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .clientError(let statusCode, _):
            return "Client error: \(statusCode)"
        case .serverError(let statusCode):
            return "Server error: \(statusCode)"
        case .unexpectedStatusCode(let code):
            return "Unexpected status code: \(code)"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .unknown:
            return "Unknown network error"
        }
    }
    
    var userFacingMessage: String {
        switch self {
        case .invalidURL, .invalidResponse, .encodingFailed, .decodingFailed, .unexpectedStatusCode, .unknown:
            return String(localized: "Unable to connect to the server. Please check your internet connection and try again.")
        case .clientError:
            return String(localized: "There was a problem with your request. Please try again.")
        case .serverError:
            return String(localized: "The server is temporarily unavailable. Please try again later.")
        case .requestFailed:
            return String(localized: "Connection failed. Please check your internet connection.")
        }
    }
}



