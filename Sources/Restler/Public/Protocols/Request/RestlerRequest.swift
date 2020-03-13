import Foundation

public protocol RestlerRequest: class {
    associatedtype D
    func onSuccess(_ handler: @escaping (D) -> Void) -> Self
    func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self
    func onCompletion(_ handler: @escaping (Result<D, Error>) -> Void) -> Self
    func start() -> RestlerTaskType?
}
