import Foundation

protocol URLSessionDataTaskType: class {
    func resume()
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTask: URLSessionDataTaskType {}
