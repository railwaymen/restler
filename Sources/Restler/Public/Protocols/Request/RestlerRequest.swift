import Foundation

public protocol RestlerRequest: class {
    associatedtype SuccessfulResponseObject
    func onSuccess(_ handler: @escaping (SuccessfulResponseObject) -> Void) -> Self
    func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self
    func onCompletion(_ handler: @escaping (Result<SuccessfulResponseObject, Error>) -> Void) -> Self
    func start() -> RestlerTaskType?
}
