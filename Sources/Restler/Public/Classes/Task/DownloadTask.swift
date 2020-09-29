import Foundation

public protocol RestlerDownloadTaskType: class {
    @available(OSX 10.13, iOS 11, *)
    var progress: Progress { get }
    var downloadProgress: Double { get }
    var state: URLSessionTask.State { get }
    
    func resume()
    func cancel()
    func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void)
    func suspend()
}

extension Restler {
    final public class DownloadTask: RestlerDownloadTaskType {
        private let urlTask: URLSessionDownloadTaskType
        
        public var id: Int { urlTask.taskIdentifier }
        
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
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
