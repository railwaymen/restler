import Foundation

/// Class for making requests to the API
public class Restler {
    private let networking: NetworkingType
    private let dispatchQueueManager: DispatchQueueManagerType
    
    /// Encoder used for encoding requests' body.
    public var encoder: JSONEncoderType
    
    /// Decoder used for decoding response's data to expected object.
    public var decoder: JSONDecoderType
    
    /// Global header sent in requests.
    public var header: Restler.Header {
        get {
            return self.networking.header
        }
        set {
            self.networking.header = newValue
        }
    }
    
    // MARK: - Initialization
    
    /// Default initializer.
    ///
    /// - Parameters:
    ///   - encoder: Encoder used for encoding requests' body.
    ///   - decoder: Decoder used for decoding response's data to expected object.
    ///
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
    
    // MARK: -
    
    // MARK: GET
    
    /// Sends GET request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType`. If decoder throws an error, calls completion with a proper error.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - query: Parameters sent in query.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If it is nil, then probably there's internal error in the Restler framework.
    ///
    public func get<D>(
        url: URL,
        query: [String: String?] = [:],
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) -> Task? where D: Decodable {
        return self.networking.makeRequest(
            url: url,
            method: .get(query: query),
            completion: self.getCompletion(with: completion))
    }
    
    /// Sends GET request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType` if it is possible.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - query: Parameters sent in query.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If it is nil, then probably there's internal error in the Restler framework.
    ///
    public func get<D>(
        url: URL,
        query: [String: String?] = [:],
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) -> Task? where D: Decodable {
        return self.networking.makeRequest(
            url: url,
            method: .get(query: query),
            completion: self.getCompletion(with: completion))
    }
    
    /// Sends GET request to the given URL.
    ///
    /// After getting a response it ignores content.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - query: Parameters sent in query.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If it is nil, then probably there's internal error in the Restler framework.
    ///
    public func get(
        url: URL,
        query: [String: String?] = [:],
        completion: @escaping VoidCompletion
    ) -> Task? {
        return self.networking.makeRequest(
            url: url,
            method: .get(query: query),
            completion: self.getCompletion(with: completion))
    }
    
    // MARK: POST
    
    /// Sends POST request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType`. If decoder throws an error, calls completion with a proper error.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - content: Encodable structure which will be sent in the body of the request.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If encoding of the content failed, it returns nil. Otherwise it can be Restler framework internal error.
    ///
    public func post<E, D>(
        url: URL,
        content: E,
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) -> Task? where E: Encodable, D: Decodable {
        do {
            let data = try self.encoder.encode(content)
            return self.networking.makeRequest(
                url: url,
                method: .post(content: data),
                completion: self.getCompletion(with: completion))
        } catch {
            completion(.failure(error))
            return nil
        }
    }
    
    /// Sends POST request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType` if it is possible.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - content: Encodable structure which will be sent in the body of the request.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If encoding of the content failed, it returns nil. Otherwise it can be Restler framework internal error.
    ///
    public func post<E, D>(
        url: URL,
        content: E,
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) -> Task? where E: Encodable, D: Decodable {
        do {
            let data = try self.encoder.encode(content)
            return self.networking.makeRequest(
                url: url,
                method: .post(content: data),
                completion: self.getCompletion(with: completion))
        } catch {
            completion(.failure(error))
            return nil
        }
    }
    
    /// Sends POST request to the given URL.
    ///
    /// After getting a response it ignores content.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - content: Encodable structure which will be sent in the body of the request.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If encoding of the content failed, it returns nil. Otherwise it can be Restler framework internal error.
    ///
    public func post<E>(
        url: URL,
        content: E,
        completion: @escaping VoidCompletion
    ) -> Task? where E: Encodable {
        do {
            let data = try self.encoder.encode(content)
            return self.networking.makeRequest(
                url: url,
                method: .post(content: data),
                completion: self.getCompletion(with: completion))
        } catch {
            completion(.failure(error))
            return nil
        }
    }
    
    // MARK: PUT
    
    /// Sends PUT request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType`. If decoder throws an error, calls completion with a proper error.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - content: Encodable structure which will be sent in the body of the request.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If encoding of the content failed, it returns nil. Otherwise it can be Restler framework internal error.
    ///
    public func put<E, D>(
        url: URL,
        content: E,
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) -> Task? where E: Encodable, D: Decodable {
        do {
            let data = try self.encoder.encode(content)
            return self.networking.makeRequest(
                url: url,
                method: .put(content: data),
                completion: self.getCompletion(with: completion))
        } catch {
            completion(.failure(error))
            return nil
        }
    }
    
    /// Sends PUT request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType` if it is possible.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - content: Encodable structure which will be sent in the body of the request.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If encoding of the content failed, it returns nil. Otherwise it can be Restler framework internal error.
    ///
    public func put<E, D>(
        url: URL,
        content: E,
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) -> Task? where E: Encodable, D: Decodable {
        do {
            let data = try self.encoder.encode(content)
            return self.networking.makeRequest(
                url: url,
                method: .put(content: data),
                completion: self.getCompletion(with: completion))
        } catch {
            completion(.failure(error))
            return nil
        }
    }
    
    /// Sends PUT request to the given URL.
    ///
    /// After getting a response it ignores content.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - content: Encodable structure which will be sent in the body of the request.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If encoding of the content failed, it returns nil. Otherwise it can be Restler framework internal error.
    ///
    public func put<E>(
        url: URL,
        content: E,
        completion: @escaping VoidCompletion
    ) -> Task? where E: Encodable {
        do {
            let data = try self.encoder.encode(content)
            return self.networking.makeRequest(
                url: url,
                method: .put(content: data),
                completion: self.getCompletion(with: completion))
        } catch {
            completion(.failure(error))
            return nil
        }
    }
    
    // MARK: DELETE
    
    /// Sends DELETE request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType`. If decoder throws an error, calls completion with a proper error.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If it is nil, then probably there's internal error in the Restler framework.
    ///
    public func delete<D>(
        url: URL,
        expectedType: D.Type = D.self,
        completion: @escaping DecodableCompletion<D>
    ) -> Task? where D: Decodable {
        return self.networking.makeRequest(
            url: url,
            method: .delete,
            completion: self.getCompletion(with: completion))
    }
    
    /// Sends DELETE request to the given URL.
    ///
    /// After getting the data in response it is decoded to the `expectedType` if it is possible.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - expectedType:
    ///         Type expected on request success to decode.
    ///         Providing optional value optionally tries to decode, but completes with success always if data task completed successfully.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If it is nil, then probably there's internal error in the Restler framework.
    ///
    public func delete<D>(
        url: URL,
        expectedType: D?.Type = D?.self,
        completion: @escaping DecodableCompletion<D?>
    ) -> Task? where D: Decodable {
        return self.networking.makeRequest(
            url: url,
            method: .delete,
            completion: self.getCompletion(with: completion))
    }
    
    /// Sends DELETE request to the given URL.
    ///
    /// After getting a response it ignores content.
    ///
    /// - Parameters:
    ///   - url: URL to send request to.
    ///   - query: Parameters sent in query.
    ///   - completion: Handler called at the and of the function. If an error occures before the request, the error is also passed to the completion handler.
    ///
    /// - Returns: Task for the request. If it is nil, then probably there's internal error in the Restler framework.
    ///
    public func delete(
        url: URL,
        completion: @escaping VoidCompletion
    ) -> Task? {
        return self.networking.makeRequest(
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
