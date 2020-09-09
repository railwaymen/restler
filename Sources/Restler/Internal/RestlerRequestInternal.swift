import Foundation

protocol RestlerRequestInternal: class {
    var dependencies: Restler.RequestDependencies { get }
    func getCompletion() -> DataCompletion
}

extension RestlerRequestInternal {
    var dispatchQueueManager: DispatchQueueManagerType { self.dependencies.dispatchQueueManager }
    
    func buildNetworkingRequest() -> RestlerTaskType? {
        guard let urlRequest = self.dependencies.urlRequest else { return nil }
        let completion = self.getCompletion()
        return self.dependencies.networking.makeRequest(
            urlRequest: urlRequest,
            completion: completion)
    }
    
    func mainThreadClosure<T>(of closure: @escaping (T) -> Void) -> (T) -> Void {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.perform(on: .main, .async) {
                closure(result)
            }
        }
    }
}

// MARK: - Structures
extension Restler {
    struct RequestDependencies {
        let networking: NetworkingType
        let encoder: RestlerJSONEncoderType
        let decoder: RestlerJSONDecoderType
        let dispatchQueueManager: DispatchQueueManagerType
        let errorParser: RestlerErrorParserType
        let errors: [Restler.Error]
        let urlRequest: URLRequest?
        
        init(
            dependencies: Restler.RequestBuilder.Dependencies,
            form: Restler.RequestBuilder.Form,
            urlRequest: URLRequest?
        ) {
            self.networking = dependencies.networking
            self.encoder = dependencies.encoder
            self.decoder = dependencies.decoder
            self.dispatchQueueManager = dependencies.dispatchQueueManager
            self.errorParser = form.errorParser
            self.errors = form.errors
            self.urlRequest = urlRequest
        }
    }
}
