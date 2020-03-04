import Foundation

extension Restler {
    public class Task {
        private let task: URLSessionDataTaskType
        
        init(task: URLSessionDataTaskType) {
            self.task = task
        }
        
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
