import Foundation

protocol URLSessionDataTaskType: class {
    func cancel()
    func suspend()
    func resume()
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTask: URLSessionDataTaskType {}
