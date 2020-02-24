import Foundation

public typealias DecodableCompletion<T: Decodable> = (Result<T, Error>) -> Void

public protocol Restlerable: class {
    func get<T>(url: URL, query: [String: String?], completion: @escaping DecodableCompletion<T>) where T: Decodable
    
    func setHeader(_ header: [String: String])
    func setHeader(value: String?, forKey key: String)
    func removeHeaderValue(forKey key: String)
}

// MARK: - Extension
extension Restlerable {
    public func get<T>(url: URL, completion: @escaping DecodableCompletion<T>) where T: Decodable {
        self.get(url: url, query: [:], completion: completion)
    }
}
