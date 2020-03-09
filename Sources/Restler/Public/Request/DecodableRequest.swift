import Foundation

extension Restler {
    public class DecodableRequest<D: Decodable>: Request<D>, RestlerRequestInternal {
        private let url: URL
        private let networking: NetworkingType
        private let encoder: RestlerJSONEncoderType
        private let decoder: RestlerJSONDecoderType
        private let method: HTTPMethod
        private let errors: [Error]
        private let decodingErrors: [RestlerErrorDecodable.Type]
        private let customHeaderFields: Restler.Header
        
        private var successCompletionHandler: ((D) -> Void)?
        private var failureCompletionHandler: ((Swift.Error) -> Void)?
        private var completionHandler: Restler.DecodableCompletion<D>?
        
        internal let dispatchQueueManager: DispatchQueueManagerType
        
        // MARK: - Initialization
        internal init(
            url: URL,
            networking: NetworkingType,
            encoder: RestlerJSONEncoderType,
            decoder: RestlerJSONDecoderType,
            dispatchQueueManager: DispatchQueueManagerType,
            method: HTTPMethod,
            errors: [Error],
            decodingErrors: [RestlerErrorDecodable.Type],
            customHeaderFields: Restler.Header
        ) {
            self.url = url
            self.networking = networking
            self.encoder = encoder
            self.decoder = decoder
            self.dispatchQueueManager = dispatchQueueManager
            self.method = method
            self.errors = errors
            self.decodingErrors = decodingErrors
            self.customHeaderFields = customHeaderFields
        }
        
        // MARK: - Public
        
        public override func onSuccess(_ handler: @escaping (D) -> Void) -> Self {
            self.successCompletionHandler = handler
            return self
        }
        
        public override func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self {
            self.failureCompletionHandler = handler
            return self
        }
        
        public override func onCompletion(_ handler: @escaping Restler.DecodableCompletion<D>) -> Self {
            self.completionHandler = handler
            return self
        }
        
        public override func start() -> RestlerTaskType? {
            let completion = self.getCompletion()
            guard self.errors.isEmpty else {
                completion(.failure(Error.multiple(self.errors)))
                return nil
            }
            return self.networking.makeRequest(
                url: self.url,
                method: self.method,
                customHeaderFields: self.customHeaderFields,
                completion: completion)
        }
    }
}

// MARK: - Private
extension Restler.DecodableRequest {
    private func getCompletion() -> DataCompletion {
        let completion: Restler.DecodableCompletion<D> = {
            [successCompletionHandler, failureCompletionHandler, completionHandler] result in
            switch result {
            case let .success(object):
                successCompletionHandler?(object)
            case let .failure(error):
                failureCompletionHandler?(error)
            }
            completionHandler?(result)
        }
        let responseHandler = self.responseHandlerClosure(completion: self.mainThreadClosure(of: completion))
        return { result in
            responseHandler(result)
        }
    }
    
    private func responseHandlerClosure<D>(completion: @escaping Restler.DecodableCompletion<D>) -> (DataResult) -> Void where D: Decodable {
        let errorDecodeHandler = self.errorsDecodeHandler(decodingErrors: self.decodingErrors)
        let decodeHandler: (Data?) throws -> D = self.hardDecodeHandler()
        return { result in
            switch result {
            case let .success(optionalData):
                do {
                    let object = try decodeHandler(optionalData)
                    completion(.success(object))
                } catch {
                    completion(.failure(Restler.Error.common(type: .invalidResponse, base: error)))
                }
            case let .failure(error):
                completion(.failure(errorDecodeHandler(error)))
            }
        }
    }
    
    private func hardDecodeHandler<D>() -> (Data?) throws -> D where D: Decodable {
        return { [decoder] optionalData in
            guard let data = optionalData else {
                throw DecodingError.valueNotFound(Data.self, DecodingError.Context(codingPath: [], debugDescription: "Response"))
            }
            return try decoder.decode(D.self, from: data)
        }
    }
}
