import Foundation
@testable import Restler

extension Restler.Request {
    func deprecatedOnSuccess(_ handler: @escaping (D) -> Void) -> Self {
        self.onSuccess(handler)
    }
    
    func deprecatedOnFailure(_ handler: @escaping (Error) -> Void) -> Self {
        self.onFailure(handler)
    }
    
    func deprecatedOnCompletion(_ handler: @escaping (Result<D, Error>) -> Void) -> Self {
        self.onCompletion(handler)
    }
    
    @discardableResult
    func deprecatedStart() -> RestlerTaskType? {
        self.start()
    }
}
