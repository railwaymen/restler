import Foundation

extension Restler {
    public class Task {
        private let task: URLSessionDataTaskType
        
        // MARK: - Getters
        
        /// The identifier of the task
        public var identifier: Int {
            return self.task.taskIdentifier
        }
        
        /// Current state of the task
        public var state: URLSessionTask.State {
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
        public func cancel() {
            self.task.cancel()
        }
        
        /// Suspend the task.
        ///
        /// A task, while suspended, produces no network traffic and is not subject to timeouts.
        /// A download task can continue transferring data at a later time. All other tasks must start over when resumed.
        ///
        public func suspend() {
            self.task.suspend()
        }
        
        /// Resume the task, if it is suspended.
        public func resume() {
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
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
}
