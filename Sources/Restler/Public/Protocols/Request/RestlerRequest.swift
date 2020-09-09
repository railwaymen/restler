import Foundation

public protocol RestlerRequest: class {
    associatedtype SuccessfulResponseObject

    @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
    func onSuccess(_ handler: @escaping (SuccessfulResponseObject) -> Void) -> Self
    
    @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
    func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self
    
    @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
    func onCompletion(_ handler: @escaping (Result<SuccessfulResponseObject, Error>) -> Void) -> Self
    
    @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
    func start() -> RestlerTaskType?
    
    @discardableResult
    func subscribe(
        onSuccess: ((_ object: SuccessfulResponseObject) -> Void)?,
        onFailure: ((_ error: Swift.Error) -> Void)?,
        onCompletion: ((_ result: Result<SuccessfulResponseObject, Error>) -> Void)?
    ) -> RestlerTaskType?
}
