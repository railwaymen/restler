import Foundation

extension Restler {
    open class Request<D>: RestlerRequest {
        open func onSuccess(_ handler: @escaping (D) -> Void) -> Self {
            return self
        }
        
        open func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self {
            return self
        }
        
        open func onCompletion(_ handler: @escaping (Result<D, Swift.Error>) -> Void) -> Self {
            return self
        }
        
        open func start() -> RestlerTaskType? {
            return nil
        }
    }
}
