import Foundation

extension Restler {
    public final class OptionalDecodableRequest<D: Decodable>: Request<D?>, RestlerRequestInternal {
        internal let dependencies: Restler.RequestDependencies
        
        private var successCompletionHandler: ((D?) -> Void)?
        private var failureCompletionHandler: ((Swift.Error) -> Void)?
        private var completionHandler: Restler.DecodableCompletion<D?>?
        
        private var errorParser: RestlerErrorParserType { self.dependencies.errorParser }
        private var decoder: RestlerJSONDecoderType { self.dependencies.decoder }
        
        // MARK: - Initialization
        internal init(dependencies: Restler.RequestDependencies) {
            self.dependencies = dependencies
        }
        
        // MARK: - Public
        public override func onSuccess(_ handler: @escaping (D?) -> Void) -> Self {
            self.successCompletionHandler = handler
            return self
        }
        
        public override func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self {
            self.failureCompletionHandler = handler
            return self
        }
        
        public override func onCompletion(_ handler: @escaping Restler.DecodableCompletion<D?>) -> Self {
            self.completionHandler = handler
            return self
        }
        
        public override func start() -> RestlerTaskType? {
            self.buildNetworkingRequest()
        }
        
        // MARK: - Internal
        internal func getCompletion() -> DataCompletion {
            let completion: Restler.DecodableCompletion<D?> = {
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
    }
}

// MARK: - Private
extension Restler.OptionalDecodableRequest {
    private func responseHandlerClosure<D>(
        completion: @escaping Restler.DecodableCompletion<D?>
    ) -> (DataResult) -> Void where D: Decodable {
        { [decoder, errorParser] result in
            switch result {
            case let .success(optionalData):
                var object: D?
                if let data = optionalData as? D {
                    object = data
                } else if let data = optionalData {
                    object = try? decoder.decode(D.self, from: data)
                }
                completion(.success(object))
            case let .failure(error):
                completion(.failure(errorParser.parse(error)))
            }
        }
    }
}
