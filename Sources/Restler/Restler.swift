import Foundation

public typealias DecodableCompletion<T: Decodable> = (Result<T, Error>) -> Void

public protocol Restlerable: class {
    func get<T>(url: URL, completion: @escaping DecodableCompletion<T>) where T: Decodable
}

public class Restler {
    private let networking: NetworkingType
    
    // MARK: - Initialization
    public init() {
        self.networking = Networking()
    }
    
    init(networking: NetworkingType) {
        self.networking = networking
    }
}

// MARK: - Structures
extension Restler {
    public enum Error: Swift.Error {
        case forbiden
        case internalFrameworkError
        case invalidParameters
        case invalidResponse
        case noInternetConnection
        case notFound
        case serverError
        case timeout
        case unauthorized
        case unknownError
        case validationError
        
        init(statusCode: Int) {
            switch statusCode {
            case 15: self = .noInternetConnection
            case 23: self = .timeout
            case 401: self = .unauthorized
            case 403: self = .forbiden
            case 404: self = .notFound
            case 422: self = .validationError
            case 500: self = .serverError
            case NSURLErrorBadServerResponse: self = .invalidResponse
            case NSURLErrorBadURL: self = .invalidParameters
            case NSURLErrorNetworkConnectionLost: self = .noInternetConnection
            case NSURLErrorTimedOut: self = .timeout
            case NSURLErrorUnknown: self = .unknownError
            default: self = .unknownError
            }
        }
    }
}

// MARK: - Restlerable
extension Restler: Restlerable {
    public func get<T>(url: URL, completion: @escaping DecodableCompletion<T>) where T: Decodable {
        let mainThreadCompletion: DecodableCompletion<T> = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        self.networking.get(url: url) { [weak self] result in
            guard let self = self else { return mainThreadCompletion(.failure(Error.internalFrameworkError)) }
            self.handleResponse(result: result, completion: mainThreadCompletion)
        }
    }
}

// MARK: - Private
extension Restler {
    private func handleResponse<T>(result: DataResult, completion: DecodableCompletion<T>) where T: Decodable {
        switch result {
        case let .success(data):
            do {
                let object: T = try self.decodeObject(data: data)
                completion(.success(object))
            } catch {
                completion(.failure(Error.invalidResponse))
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
    
    private func decodeObject<T>(data: Data) throws -> T where T: Decodable {
        return try JSONDecoder().decode(T.self, from: data)
    }
}
