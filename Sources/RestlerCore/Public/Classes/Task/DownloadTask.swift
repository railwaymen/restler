import Foundation

public protocol RestlerDownloadTaskType: RestlerTaskType {
    @available(OSX 10.13, iOS 11, *)
    var progress: Progress { get }
    var downloadProgress: Double { get }
    
    func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void)
}

extension Restler {
    final public class DownloadTask: RestlerDownloadTaskType {
        private let urlTask: URLSessionDownloadTaskType
        
        public var identifier: Int { urlTask.taskIdentifier }
        
        /// A progress of the download task.
        @available(OSX 10.13, iOS 11, *)
        public var progress: Progress { urlTask.progress }
        
        /// A progress of downloading data. A number in range 0.0 - 1.0.
        public var downloadProgress: Double {
            let max: Double
            if #available(OSX 10.13, iOS 11, *) {
                max = Double(urlTask.countOfBytesClientExpectsToReceive)
            } else {
                max = Double(urlTask.countOfBytesExpectedToReceive)
            }
            return Double(urlTask.countOfBytesReceived) / max
        }
        
        /// A state of the download task.
        public var state: URLSessionTask.State { urlTask.state }
        
        // MARK: - Initialization
        init(urlTask: URLSessionDownloadTaskType) {
            self.urlTask = urlTask
        }
        
        // MARK: - Public
        public func resume() {
            urlTask.resume()
        }
        
        public func cancel() {
            urlTask.cancel()
        }
        
        public func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void) {
            urlTask.cancel(byProducingResumeData: completionHandler)
        }
        
        public func suspend() {
            urlTask.suspend()
        }
    }
}

// MARK: - Hashable
extension Restler.DownloadTask: Hashable {
    public static func == (lhs: Restler.DownloadTask, rhs: Restler.DownloadTask) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
