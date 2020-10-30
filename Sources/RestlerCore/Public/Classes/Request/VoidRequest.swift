import Foundation

extension Restler {
    public final class VoidRequest: Request<Void>, RestlerRequestInternal {
        internal let dependencies: Restler.RequestDependencies
        internal var form: Restler.RequestForm = .init()
        
        private var successCompletionHandler: ((SuccessfulResponseObject) -> Void)?
        private var failureCompletionHandler: ((Swift.Error) -> Void)?
        private var completionHandler: Restler.VoidCompletion?
        
        private var errorParser: RestlerErrorParserType { self.dependencies.errorParser }
        
        // MARK: - Initialization
        internal init(dependencies: Restler.RequestDependencies) {
            self.dependencies = dependencies
        }
        
        // MARK: - Public
        public override func onSuccess(_ handler: @escaping (SuccessfulResponseObject) -> Void) -> Self {
            self.successCompletionHandler = handler
            return self
        }
        
        public override func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self {
            self.failureCompletionHandler = handler
            return self
        }
        
        public override func onCompletion(_ handler: @escaping Restler.VoidCompletion) -> Self {
            self.completionHandler = handler
            return self
        }
        
        public override func start() -> RestlerTaskType? {
            self.buildNetworkingRequest()
        }
        
        public override func using(session: URLSession) -> Self {
            self.form.urlSession = session
            return self
        }
        
        public override func subscribe(
            onSuccess: ((SuccessfulResponseObject) -> Void)? = nil,
            onFailure: ((Swift.Error) -> Void)? = nil,
            onCompletion: ((Result<SuccessfulResponseObject, Swift.Error>) -> Void)? = nil
        ) -> RestlerTaskType? {
            self.successCompletionHandler = onSuccess
            self.failureCompletionHandler = onFailure
            self.completionHandler = onCompletion
            return self.buildNetworkingRequest()
        }
        
        // MARK: - Internal
        internal func getCompletion() -> DataCompletion {
            let completion: Restler.VoidCompletion = {
                [successCompletionHandler, failureCompletionHandler, completionHandler] result in
                switch result {
                case let .success(object):
                    successCompletionHandler?(object)
                case let .failure(error):
                    failureCompletionHandler?(error)
                }
                completionHandler?(result)
            }
            let responseHandler = self.responseHandlerClosure(completion: self.customQueueClosure(of: completion))
            return { result in
                responseHandler(result)
            }
        }
    }
}

// MARK: - Private
extension Restler.VoidRequest {
    private func responseHandlerClosure(completion: @escaping Restler.VoidCompletion) -> (DataResult) -> Void {
        return { [errorParser] result in
            switch result {
            case .success:
                completion(.success(Void()))
            case let .failure(error):
                completion(.failure(errorParser.parse(error)))
            }
        }
    }
}
