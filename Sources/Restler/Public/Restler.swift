import Foundation

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

// MARK: - Restlerable
extension Restler: Restlerable {
    public func get<T>(url: URL, query: [String: String?], completion: @escaping DecodableCompletion<T>) where T: Decodable {
        let mainThreadCompletion: DecodableCompletion<T> = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        self.networking.get(url: url, query: query) { [weak self] result in
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
