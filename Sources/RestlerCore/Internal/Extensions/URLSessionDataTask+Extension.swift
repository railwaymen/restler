import Foundation

protocol URLSessionDataTaskType: class {
    var taskIdentifier: Int { get }
    var state: URLSessionTask.State { get }
    func cancel()
    func suspend()
    func resume()
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTask: URLSessionDataTaskType {}
