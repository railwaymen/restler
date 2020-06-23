import Foundation
import Combine

typealias DataResult = Result<Data?, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType: class {
    func makeRequest(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?,
        completion: @escaping DataCompletion) -> Restler.Task?
    
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func getPublisher(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?
    ) -> URLSession.DataTaskPublisher?
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
    func makeRequest(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?,
        completion: @escaping DataCompletion
    ) -> Restler.Task? {
        guard var request = self.buildURLRequest(
            url: url,
            httpMethod: method,
            header: header) else {
                completion(.failure(Restler.internalError()))
                return nil
        }
        customRequestModification?(&request)
        return Restler.Task(task: self.runDataTask(request: request, completion: completion))
    }
    
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func getPublisher(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?
    ) -> URLSession.DataTaskPublisher? {
        guard var request = self.buildURLRequest(
            url: url,
            httpMethod: method,
            header: header) else {
                return nil
        }
        customRequestModification?(&request)
        return self.session.dataTaskPublisher(for: request)
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
        let task = self.session.dataTask(with: request) { response in
            self.handleResponse(response: response, completion: completion)
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
        let errorType = Restler.ErrorType(statusCode: result.response?.statusCode ?? (result.error as NSError?)?.code ?? 0) ?? .unknownError
        return Restler.Error.request(type: errorType, response: Restler.Response(result))
    }
}
