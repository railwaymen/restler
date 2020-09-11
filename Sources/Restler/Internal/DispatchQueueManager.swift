import Foundation

protocol DispatchQueueManagerType: class {
    func async(on queue: DispatchQueue?, execute action: @escaping @convention(block) () -> Void)
}

final class DispatchQueueManager {}

// MARK: - DispatchQueueManagerType
extension DispatchQueueManager: DispatchQueueManagerType {
    func async(on queue: DispatchQueue?, execute action: @escaping @convention(block) () -> Void) {
        guard let queue = queue else { return action() }
        queue.async(execute: action)
    }
}
