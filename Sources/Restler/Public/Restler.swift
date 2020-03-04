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
extension Restler {
    public func get<D>(
        url: URL,
        query: [String: String?] = [:],
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) where D: Decodable {
        self.networking.makeRequest(
            url: url,
            method: .get(query: query),
            completion: self.getCompletion(with: completion))
    }
    
    public func get<D>(
        url: URL,
        query: [String: String?] = [:],
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) where D: Decodable {
        self.networking.makeRequest(
            url: url,
            method: .get(query: query),
            completion: self.getCompletion(with: completion))
    }
    
    public func get(
        url: URL,
        query: [String: String?] = [:],
        completion: @escaping VoidCompletion
    ) {
        self.networking.makeRequest(
            url: url,
            method: .get(query: query),
            completion: self.getCompletion(with: completion))
    }
    
    public func post<E, D>(
        url: URL,
        content: E,
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) throws where E: Encodable, D: Decodable {
        let data = try self.encoder.encode(content)
        self.networking.makeRequest(
            url: url,
            method: .post(content: data),
            completion: self.getCompletion(with: completion))
    }
    
    public func post<E, D>(
        url: URL,
        content: E,
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) throws where E: Encodable, D: Decodable {
        let data = try self.encoder.encode(content)
        self.networking.makeRequest(
            url: url,
            method: .post(content: data),
            completion: self.getCompletion(with: completion))
    }
    
    public func post<E>(
        url: URL,
        content: E,
        completion: @escaping VoidCompletion
    ) throws where E: Encodable {
        let data = try self.encoder.encode(content)
        self.networking.makeRequest(
            url: url,
            method: .post(content: data),
            completion: self.getCompletion(with: completion))
    }
    
    public func put<E, D>(
        url: URL,
        content: E,
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) throws where E: Encodable, D: Decodable {
        let data = try self.encoder.encode(content)
        self.networking.makeRequest(
            url: url,
            method: .put(content: data),
            completion: self.getCompletion(with: completion))
    }
    
    public func put<E, D>(
        url: URL,
        content: E,
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) throws where E: Encodable, D: Decodable {
        let data = try self.encoder.encode(content)
        self.networking.makeRequest(
            url: url,
            method: .put(content: data),
            completion: self.getCompletion(with: completion))
    }
    
    public func put<E>(
        url: URL,
        content: E,
        completion: @escaping VoidCompletion
    ) throws where E: Encodable {
        let data = try self.encoder.encode(content)
        self.networking.makeRequest(
            url: url,
            method: .put(content: data),
            completion: self.getCompletion(with: completion))
    }
    
    public func delete<D>(
        url: URL,
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) where D: Decodable {
        self.networking.makeRequest(
            url: url,
            method: .delete,
            completion: self.getCompletion(with: completion))
    }
    
    public func delete<D>(
        url: URL,
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) where D: Decodable {
        self.networking.makeRequest(
            url: url,
            method: .delete,
            completion: self.getCompletion(with: completion))
    }
    
    public func delete(
        url: URL,
        completion: @escaping VoidCompletion
    ) {
        self.networking.makeRequest(
            url: url,
            method: .delete,
            completion: self.getCompletion(with: completion))
    }
}

// MARK: - Private
extension Restler {
    private func getCompletion(with completion: @escaping VoidCompletion) -> DataCompletion {
        let mainThreadCompletion = self.mainThreadClosure(of: completion)
        return { result in
            switch result {
            case .success:
                mainThreadCompletion(.success(Void()))
            case let .failure(error):
                mainThreadCompletion(.failure(error))
            }
        }
    }
    
    private func getCompletion<D>(with completion: @escaping DecodableCompletion<D>) -> DataCompletion where D: Decodable {
        let responseHandler = self.responseHandlerClosure(completion: self.mainThreadClosure(of: completion))
        return { result in
            responseHandler(result)
        }
    }
    
    private func getCompletion<D>(with completion: @escaping DecodableCompletion<D?>) -> DataCompletion where D: Decodable {
        let responseHandler = self.responseHandlerClosure(completion: self.mainThreadClosure(of: completion))
        return { result in
            responseHandler(result)
        }
    }
    
    private func mainThreadClosure(of closure: @escaping VoidCompletion) -> VoidCompletion {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.perform(on: .main, .async) {
                closure(result)
            }
        }
    }
    
    private func mainThreadClosure<D>(of closure: @escaping DecodableCompletion<D>) -> DecodableCompletion<D> where D: Decodable {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.perform(on: .main, .async) {
                closure(result)
            }
        }
    }
    
    private func responseHandlerClosure<D>(completion: @escaping DecodableCompletion<D>) -> (DataResult) -> Void where D: Decodable {
        return { [decoder] result in
            switch result {
            case let .success(optionalData):
                guard let data = optionalData else {
                    completion(.failure(Error.invalidResponse))
                    return
                }
                do {
                    let object = try decoder.decode(D.self, from: data)
                    completion(.success(object))
                } catch {
                    completion(.failure(Error.invalidResponse))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func responseHandlerClosure<D>(completion: @escaping DecodableCompletion<D?>) -> (DataResult) -> Void where D: Decodable {
        return { [decoder] result in
            switch result {
            case let .success(optionalData):
                var object: D?
                if let data = optionalData {
                    object = try? decoder.decode(D.self, from: data)
                }
                completion(.success(object))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
