import Foundation

@MainActor
final class JSONStorageManager {
    static let shared = JSONStorageManager()
    private init() {}
    
    func load<T: Decodable>(filename: String) -> [T] {
        // Try bundle first
        if let url = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".json", with: ""), withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode([T].self, from: data)
            } catch {
                AppLogger.error("Failed to load from bundle \(filename)", error: error)
            }
        }
        // Fallback to documents directory
        let url = documentsURL(for: filename)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            return []
        }
    }
    
    func save<T: Encodable>(_ value: [T], filename: String) {
        let url = documentsURL(for: filename)
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: .atomic)
        } catch {
            AppLogger.error("Failed to save \(filename)", error: error)
        }
    }
    
    /// Returns the local file URL for a given filename
    func getLocalFileURL(for filename: String) -> URL? {
        // Check if file exists in bundle first
        if let bundleURL = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".json", with: ""), withExtension: "json") {
            return bundleURL
        }
        // Return documents directory URL
        let url = documentsURL(for: filename)
        // Check if file exists
        if FileManager.default.fileExists(atPath: url.path) {
            return url
        }
        return nil
    }
    
    private func documentsURL(for filename: String) -> URL {
        let fm = FileManager.default
        guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            AppLogger.error("Failed to get documents directory", log: AppLogger.general)
            // Fallback to temporary directory if documents directory is unavailable
            return fm.temporaryDirectory.appendingPathComponent(filename)
        }
        return dir.appendingPathComponent(filename)
    }
}
