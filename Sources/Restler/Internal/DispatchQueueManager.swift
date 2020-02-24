import Foundation

protocol DispatchQueueManagerType: class {
    func perform(on thread: DispatchQueueThread, _ syncType: DispatchQueueSynchronizationType, action: @escaping () -> Void)
}

class DispatchQueueManager: DispatchQueueManagerType {
    func perform(on thread: DispatchQueueThread, _ synchType: DispatchQueueSynchronizationType, action: @escaping () -> Void) {
        switch synchType {
        case .async: thread.queue.async(execute: action)
        case .sync: thread.queue.sync(execute: action)
        }
    }
}
