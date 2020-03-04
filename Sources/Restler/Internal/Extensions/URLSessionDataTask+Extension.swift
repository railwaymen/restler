import Foundation

protocol URLSessionDataTaskType: class {
    var taskIdentifier: Int { get }
    func cancel()
    func suspend()
    func resume()
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTask: URLSessionDataTaskType {}
