import Foundation

protocol RestlerRequestInternal: class {
    var dispatchQueueManager: DispatchQueueManagerType { get }
}

extension RestlerRequestInternal {
    func mainThreadClosure<T>(of closure: @escaping (T) -> Void) -> (T) -> Void {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.perform(on: .main, .async) {
                closure(result)
            }
        }
    }
}
