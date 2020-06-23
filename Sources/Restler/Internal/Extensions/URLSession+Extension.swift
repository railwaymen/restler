import Foundation

protocol URLSessionType: class {
    func dataTask(with request: URLRequest, completion: @escaping (HTTPRequestResponse) -> Void) -> URLSessionDataTaskType
}

// MARK: - URLSessionType
extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest, completion: @escaping (HTTPRequestResponse) -> Void) -> URLSessionDataTaskType {
        return self.dataTask(with: request) { (data, response, error) in
            completion(HTTPRequestResponse(data: data, response: response as? HTTPURLResponseType, error: error))
        }
    }
}
