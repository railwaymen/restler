import Foundation

protocol URLSessionDownloadTaskType: class {
    var taskIdentifier: Int { get }
    
    @available(OSX 10.13, iOS 11, *)
    var progress: Progress { get }
    @available(OSX 10.13, iOS 11, *)
    var countOfBytesClientExpectsToReceive: Int64 { get }
    var countOfBytesExpectedToReceive: Int64 { get }
    var countOfBytesReceived: Int64 { get }
    
    var state: URLSessionTask.State { get }
    
    func resume()
    func suspend()
    func cancel()
    func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void)
}

extension URLSessionDownloadTask: URLSessionDownloadTaskType {}
