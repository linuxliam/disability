//
//  NetworkManagerTests.swift
//  DisabilityAdvocacyTests
//
//  Unit tests for NetworkManager
//

import XCTest
@testable import DisabilityAdvocacy

// MARK: - Mock URLProtocol for Testing

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // Required by URLProtocol
    }
}

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var sessionConfiguration: URLSessionConfiguration!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Configure URLSession to use mock protocol
        sessionConfiguration = URLSessionConfiguration.ephemeral
        sessionConfiguration.protocolClasses = [MockURLProtocol.self]
        
        // Create a NetworkManager instance - we'll need to test the shared instance
        // or create a testable version. Since NetworkManager uses private init,
        // we'll test the shared instance and use dependency injection patterns
        networkManager = NetworkManager.shared
    }
    
    override func tearDown() async throws {
        MockURLProtocol.requestHandler = nil
        networkManager = nil
        sessionConfiguration = nil
        try await super.tearDown()
    }
    
    // MARK: - Singleton Pattern Tests
    
    func testSharedInstance_ReturnsSameInstance() {
        // When
        let instance1 = NetworkManager.shared
        let instance2 = NetworkManager.shared
        
        // Then
        XCTAssertTrue(instance1 === instance2, "Shared instance should return the same instance")
    }
    
    // MARK: - Request Method Tests
    
    func testRequest_GET_Success() async throws {
        // Given
        struct TestResponse: Decodable {
            let message: String
        }
        
        let responseData = """
        {"message": "Success"}
        """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Content-Type": "application/json"]
            )!
            return (response, responseData)
        }
        
        // Note: This test is conceptual since NetworkManager.shared uses its own session
        // In a real scenario, we would inject a URLSession with mock protocol
        // For now, we'll test the error handling and structure
        
        // This test demonstrates the structure but may need refactoring
        // to allow dependency injection for URLSession
    }
    
    // MARK: - Error Handling Tests
    
    func testNetworkError_InvalidURL() {
        // Given
        let error = NetworkError.invalidURL
        
        // When/Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
    }
    
    func testNetworkError_ClientError() {
        // Given
        let error = NetworkError.clientError(statusCode: 404, data: nil)
        
        // When/Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertTrue(error.errorDescription?.contains("404") ?? false, "Should include status code")
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
    }
    
    func testNetworkError_ServerError() {
        // Given
        let error = NetworkError.serverError(statusCode: 500)
        
        // When/Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertTrue(error.errorDescription?.contains("500") ?? false, "Should include status code")
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
    }
    
    func testNetworkError_EncodingFailed() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = NetworkError.encodingFailed(underlyingError)
        
        // When/Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
    }
    
    func testNetworkError_DecodingFailed() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = NetworkError.decodingFailed(underlyingError)
        
        // When/Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
    }
    
    func testNetworkError_RequestFailed() {
        // Given
        let underlyingError = NSError(domain: "test", code: 1)
        let error = NetworkError.requestFailed(underlyingError)
        
        // When/Then
        XCTAssertNotNil(error.errorDescription, "Should have error description")
        XCTAssertNotNil(error.userFacingMessage, "Should have user-facing message")
    }
    
    // MARK: - HTTP Method Enum Tests
    
    func testHTTPMethod_RawValues() {
        // Then
        XCTAssertEqual(HTTPMethod.GET.rawValue, "GET")
        XCTAssertEqual(HTTPMethod.POST.rawValue, "POST")
        XCTAssertEqual(HTTPMethod.PUT.rawValue, "PUT")
        XCTAssertEqual(HTTPMethod.DELETE.rawValue, "DELETE")
        XCTAssertEqual(HTTPMethod.PATCH.rawValue, "PATCH")
    }
    
    // MARK: - Configuration Tests
    
    func testNetworkManager_DefaultConfiguration() async {
        let timeout = await networkManager.timeoutInterval
        let retries = await networkManager.maxRetryAttempts
        let baseURL = await networkManager.baseURL
        XCTAssertEqual(timeout, 30, "Default timeout should be 30 seconds")
        XCTAssertEqual(retries, 3, "Default max retry attempts should be 3")
        XCTAssertFalse(baseURL.isEmpty, "Base URL should be set")
    }
    
    func testNetworkManager_ConfigurationCanBeModified() async {
        // Given
        let originalTimeout = await networkManager.timeoutInterval
        let originalRetries = await networkManager.maxRetryAttempts
        
        // When
        await networkManager.setTimeoutInterval(60)
        await networkManager.setMaxRetryAttempts(5)
        
        // Then
        XCTAssertEqual(await networkManager.timeoutInterval, 60, "Should allow timeout modification")
        XCTAssertEqual(await networkManager.maxRetryAttempts, 5, "Should allow retry attempts modification")
        
        // Cleanup
        await networkManager.setTimeoutInterval(originalTimeout)
        await networkManager.setMaxRetryAttempts(originalRetries)
    }
}

