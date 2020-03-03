import Foundation

public class Restler {
    private let networking: NetworkingType
    private let dispatchQueueManager: DispatchQueueManagerType
    
    public var encoder: JSONEncoderType
    public var decoder: JSONDecoderType
    
    public var header: Restler.Header {
        get {
            return self.networking.header
        }
        set {
            self.networking.header = newValue
        }
    }
    
    // MARK: - Initialization
    public convenience init(
        encoder: JSONEncoderType,
        decoder: JSONDecoderType
    ) {
        self.init(
            networking: Networking(),
            dispatchQueueManager: DispatchQueueManager(),
            encoder: encoder,
            decoder: decoder)
    }
    
    init(
        networking: NetworkingType,
        dispatchQueueManager: DispatchQueueManagerType,
        encoder: JSONEncoderType,
        decoder: JSONDecoderType
    ) {
        self.networking = networking
        self.dispatchQueueManager = dispatchQueueManager
        self.encoder = encoder
        self.decoder = decoder
    }
}

// MARK: - Restlerable
extension Restler: Restlerable {
    public func get<D>(url: URL, query: [String: String?], completion: @escaping DecodableCompletion<D>) where D: Decodable {
        self.networking.makeRequest(
            url: url,
            method: .get(query: query),
            completion: self.getCompletion(with: completion))
    }
    
    public func post<E, D>(url: URL, content: E, completion: @escaping DecodableCompletion<D>) throws where E: Encodable, D: Decodable {
        let data = try self.encoder.encode(content)
        self.networking.makeRequest(
            url: url,
            method: .post(content: data),
            completion: self.getCompletion(with: completion))
    }
}

// MARK: - Private
extension Restler {
    private func getCompletion<D>(with completion: @escaping DecodableCompletion<D>) -> DataCompletion where D: Decodable {
        let mainThreadCompletion = self.mainThreadClosure(of: completion)
        return { [weak self] result in
            guard let self = self else { return mainThreadCompletion(.failure(Error.internalFrameworkError)) }
            self.handleResponse(result: result, completion: mainThreadCompletion)
        }
    }
    
    private func mainThreadClosure<D>(of closure: @escaping DecodableCompletion<D>) -> DecodableCompletion<D> where D: Decodable {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.perform(on: .main, .async) {
                closure(result)
            }
        }
    }
    
    private func handleResponse<D>(result: DataResult, completion: DecodableCompletion<D>) where D: Decodable {
        switch result {
        case let .success(data):
            do {
                let object = try self.decoder.decode(D.self, from: data)
                completion(.success(object))
            } catch {
                completion(.failure(Error.invalidResponse))
            }
        case let .failure(error):
            completion(.failure(error))
        }
    }
}
