import Foundation

public typealias HeaderParameters = [String: String]
public typealias DecodableResult<T: Decodable> = Result<T, Error>
public typealias DecodableCompletion<T: Decodable> = (DecodableResult<T>) -> Void

public protocol Restlerable: class {
    var header: Restler.Header { get set }
    func get<T>(url: URL, query: [String: String?], completion: @escaping DecodableCompletion<T>) where T: Decodable
}

// MARK: - Extension
extension Restlerable {
    public func get<T>(url: URL, completion: @escaping DecodableCompletion<T>) where T: Decodable {
        self.get(url: url, query: [:], completion: completion)
    }
}
