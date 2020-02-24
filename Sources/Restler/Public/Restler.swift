import Foundation

public class Restler {
    private let networking: NetworkingType
    private let dispatchQueueManager: DispatchQueueManagerType
    
    // MARK: - Initialization
    public init() {
        self.networking = Networking()
        self.dispatchQueueManager = DispatchQueueManager()
    }
    
    init(
        networking: NetworkingType,
        dispatchQueueManager: DispatchQueueManagerType
    ) {
        self.networking = networking
        self.dispatchQueueManager = dispatchQueueManager
    }
}

// MARK: - Restlerable
extension Restler: Restlerable {
    public func get<T>(url: URL, query: [String: String?], completion: @escaping DecodableCompletion<T>) where T: Decodable {
        let mainThreadCompletion = self.mainThreadClosure(of: completion)
        self.networking.makeRequest(url: url, method: .get(query: query)) { [weak self] result in
            guard let self = self else { return mainThreadCompletion(.failure(Error.internalFrameworkError)) }
            self.handleResponse(result: result, completion: mainThreadCompletion)
        }
    }
    
    public func setHeader(_ header: [String: String]) {
        self.networking.header = header
    }
    
    public func setHeader(value: String?, forKey key: String) {
        self.networking.header[key] = value
    }
    
    public func removeHeaderValue(forKey key: String) {
        self.networking.header.removeValue(forKey: key)
    }
}

// MARK: - Private
extension Restler {
    private func mainThreadClosure<T>(of closure: @escaping DecodableCompletion<T>) -> DecodableCompletion<T> where T: Decodable {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.perform(on: .main, .async) {
                closure(result)
            }
        }
    }
    
    private func handleResponse<T>(result: DataResult, completion: DecodableCompletion<T>) where T: Decodable {
        switch result {
        case let .success(data):
            do {
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(Error.invalidResponse))
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}
