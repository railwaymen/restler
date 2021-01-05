import Foundation

protocol RestlerRequestInternal: class {
    var dependencies: Restler.RequestDependencies { get }
    var form: Restler.RequestForm { get }
    func getCompletion() -> DataCompletion
}

extension RestlerRequestInternal {
    var dispatchQueueManager: DispatchQueueManagerType { self.dependencies.dispatchQueueManager }
    
    func buildNetworkingRequest() -> RestlerTaskType? {
        guard let urlRequest = self.dependencies.urlRequest else { return nil }
        let completion = self.getCompletion()
        return self.dependencies.networking.makeRequest(
            urlRequest: urlRequest,
            urlSession: self.form.urlSession,
            eventLogger: self.dependencies.eventLogger,
            completion: completion)
    }
    
    func customQueueClosure<T>(of closure: @escaping (T) -> Void) -> (T) -> Void {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.async(on: self.dependencies.customDispatchQueue) {
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
        let eventLogger: EventLoggerLogging
        let errors: [Restler.Error]
        let customDispatchQueue: DispatchQueue?
        let downloadResumeData: Data?
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
            self.eventLogger = dependencies.eventLogger
            self.errorParser = form.errorParser
            self.errors = form.errors
            self.customDispatchQueue = form.customDispatchQueue
            self.downloadResumeData = form.downloadResumeData
            self.urlRequest = urlRequest
        }
    }
    
    struct RequestForm {
        var urlSession: URLSessionType?
    }
}
