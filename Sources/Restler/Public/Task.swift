import Foundation

extension Restler {
    public class Task {
        private let task: URLSessionDataTaskType
        
        // MARK: - Getters
        public var identifier: Int {
            return self.task.taskIdentifier
        }
        
        // MARK: - Initialization
        init(task: URLSessionDataTaskType) {
            self.task = task
        }
        
        // MARK: - Public
        public func cancel() {
            self.task.cancel()
        }
        
        public func suspend() {
            self.task.suspend()
        }
        
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
