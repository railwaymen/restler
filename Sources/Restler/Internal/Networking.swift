import Foundation

typealias DataResult = Result<Data?, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType: class {
    func makeRequest(url: URL, method: HTTPMethod, header: Restler.Header, completion: @escaping DataCompletion) -> Restler.Task?
}

class Networking {
    private let session: URLSessionType
        
    // MARK: - Initialization
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

// MARK: - NetworkingType
extension Networking: NetworkingType {
    func makeRequest(url: URL, method: HTTPMethod, header: Restler.Header, completion: @escaping DataCompletion) -> Restler.Task? {
        guard let request = self.buildURLRequest(
            url: url,
            httpMethod: method,
            header: header) else {
                completion(.failure(Restler.Error.common(
                    type: .internalFrameworkError,
                    base: NSError(domain: "Restler", code: 0, userInfo: ["file": #file, "line": #line]))))
                return nil
        }
        return Restler.Task(task: self.runDataTask(request: request, completion: completion))
    }
}

// MARK: - Private
extension Networking {
    private func buildURLRequest(url: URL, httpMethod: HTTPMethod, header: Restler.Header) -> URLRequest? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = httpMethod.query
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header.raw
        request.httpMethod = httpMethod.name
        request.httpBody = httpMethod.content
        return request
    }
    
    private func runDataTask(request: URLRequest, completion: @escaping DataCompletion) -> URLSessionDataTaskType {
        let task = self.session.dataTask(with: request) { [weak self] response in
            self?.handleResponse(response: response, completion: completion)
        }
        task.resume()
        return task
    }
    
    private func handleResponse(response: HTTPRequestResponse, completion: DataCompletion) {
        guard response.error == nil, response.response?.isSuccessful ?? false else {
            completion(.failure(self.handle(result: response)))
            return
        }
        completion(.success(response.data))
    }
    
    private func handle(result: HTTPRequestResponse) -> Error {
        let errorType = Restler.ErrorType(statusCode: result.response?.statusCode ?? 0) ?? .unknownError
        return Restler.Error.request(type: errorType, response: Restler.Response(result))
    }
}
