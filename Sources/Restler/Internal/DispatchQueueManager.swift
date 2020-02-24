import Foundation

protocol DispatchQueueManagerType: class {
    func perform(on thread: DispatchQueueThread, _ syncType: DispatchQueueSynchronizationType, action: @escaping () -> Void)
}

enum DispatchQueueThread: Equatable {
    case main
    case background(qos: DispatchQoS.QoSClass)
    
    fileprivate var queue: DispatchQueue {
        switch self {
        case .main: return DispatchQueue.main
        case let .background(qos): return DispatchQueue.global(qos: qos)
        }
    }
}

enum DispatchQueueSynchronizationType: Equatable {
    case sync
    case async
}

class DispatchQueueManager: DispatchQueueManagerType {
    func perform(on thread: DispatchQueueThread, _ synchType: DispatchQueueSynchronizationType, action: @escaping () -> Void) {
        switch synchType {
        case .async: thread.queue.async(execute: action)
        case .sync: thread.queue.sync(execute: action)
        }
    }
}
