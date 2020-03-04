import Foundation

typealias DataResult = Result<Data?, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType: class {
    var header: Restler.Header { get set }
    func makeRequest(url: URL, method: HTTPMethod, completion: @escaping DataCompletion) -> Restler.Task?
}

class Networking {
    private let session: URLSessionType
    
    var header: Restler.Header = .init()
    
    // MARK: - Initialization
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

// MARK: - NetworkingType
extension Networking: NetworkingType {
    func makeRequest(url: URL, method: HTTPMethod, completion: @escaping DataCompletion) -> Restler.Task? {
        guard let request = self.buildURLRequest(url: url, httpMethod: method) else {
            completion(.failure(Restler.Error.internalFrameworkError))
            return nil
        }
        return Restler.Task(task: self.runDataTask(request: request, completion: completion))
    }
}

// MARK: - Private
extension Networking {
    private func buildURLRequest(url: URL, httpMethod: HTTPMethod) -> URLRequest? {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return nil }
        urlComponents.queryItems = httpMethod.query?.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = self.header.raw
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
        let defaultReturnedError = result.error ?? Restler.Error.unknownError
        return Restler.Error(result: result) ?? defaultReturnedError
    }
}
