import Foundation

protocol RestlerRequestInternal: class {
    var dependencies: Restler.RequestDependencies { get }
    func getCompletion() -> DataCompletion
}

extension RestlerRequestInternal {
    var dispatchQueueManager: DispatchQueueManagerType { self.dependencies.dispatchQueueManager }
    
    func buildNetworkingRequest() -> RestlerTaskType? {
        let completion = self.getCompletion()
        guard self.dependencies.errors.isEmpty else {
            completion(.failure(Restler.Error.multiple(self.dependencies.errors)))
            return nil
        }
        return self.dependencies.networking.makeRequest(
            url: self.dependencies.url,
            method: self.dependencies.method,
            header: self.dependencies.header,
            customRequestModification: self.dependencies.customRequestModification,
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
        let url: URL
        let networking: NetworkingType
        let encoder: RestlerJSONEncoderType
        let decoder: RestlerJSONDecoderType
        let dispatchQueueManager: DispatchQueueManagerType
        let errorParser: RestlerErrorParserType
        let method: HTTPMethod
        let errors: [Restler.Error]
        let header: Restler.Header
        let customRequestModification: ((inout URLRequest) -> Void)?
        
        init(
            dependencies: Restler.RequestBuilder.Dependencies,
            form: Restler.RequestBuilder.Form
        ) {
            self.url = dependencies.url
            self.networking = dependencies.networking
            self.encoder = dependencies.encoder
            self.decoder = dependencies.decoder
            self.dispatchQueueManager = dependencies.dispatchQueueManager
            self.errorParser = form.errorParser
            self.method = dependencies.method.combinedWith(query: form.query, body: form.body)
            self.errors = form.errors
            self.header = form.header
            self.customRequestModification = form.customRequestModification
        }
    }
}
