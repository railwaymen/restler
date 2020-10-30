import Foundation

public protocol RestlerTaskType: class {
    var identifier: Int { get }
    var state: URLSessionTask.State { get }
    
    func cancel()
    func suspend()
    func resume()
}

extension Restler {
    open class Task: RestlerTaskType {
        private let task: URLSessionDataTaskType
        
        // MARK: - Getters
        
        /// The identifier of the task
        open var identifier: Int {
            return self.task.taskIdentifier
        }
        
        /// Current state of the task
        open var state: URLSessionTask.State {
            return self.task.state
        }
        
        // MARK: - Initialization
        init(task: URLSessionDataTaskType) {
            self.task = task
        }
        
        // MARK: - Public
        
        /// Cancel the task.
        ///
        /// After calling this, completion of the task is called with error `Restler.Error.requestCancelled`.
        ///
        open func cancel() {
            self.task.cancel()
        }
        
        /// Suspend the task.
        ///
        /// A task, while suspended, produces no network traffic and is not subject to timeouts.
        /// A download task can continue transferring data at a later time. All other tasks must start over when resumed.
        ///
        open func suspend() {
            self.task.suspend()
        }
        
        /// Resume the task, if it is suspended.
        open func resume() {
            self.task.resume()
        }
    }
}

// MARK: - Equatable
extension Restler.Task: Equatable {
    public static func == (lhs: Restler.Task, rhs: Restler.Task) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

// MARK: - Hashable
extension Restler.Task: Hashable {
    open func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
}
