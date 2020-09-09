import Foundation
#if canImport(Combine)
import Combine
#endif

typealias DataResult = Result<Data?, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType: class {
    func makeRequest(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion) -> Restler.Task
    
    func buildRequest(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?) -> URLRequest?
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func getPublisher(urlRequest: URLRequest) -> URLSession.DataTaskPublisher
    #endif
}

final class Networking {
    private let session: URLSessionType
        
    // MARK: - Initialization
    init(session: URLSessionType = URLSession.shared) {
        self.session = session
    }
}

// MARK: - NetworkingType
extension Networking: NetworkingType {
    func makeRequest(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion
    ) -> Restler.Task {
        Restler.Task(task: self.runDataTask(
            request: urlRequest,
            eventLogger: eventLogger,
            completion: completion))
    }
    
    func buildRequest(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?
    ) -> URLRequest? {
        guard var request = self.buildURLRequest(
            url: url,
            httpMethod: method,
            header: header) else {
                return nil
        }
        customRequestModification?(&request)
        return request
    }
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func getPublisher(urlRequest: URLRequest) -> URLSession.DataTaskPublisher {
        self.session.dataTaskPublisher(for: urlRequest)
    }
    #endif
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
    
    private func runDataTask(
        request: URLRequest,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion
    ) -> URLSessionDataTaskType {
        let startTime: DispatchTime = .now()
        let task = self.session.dataTask(with: request) { response in
            let elapsedTime: DispatchTimeInterval
            if #available(OSX 10.15, *) {
                elapsedTime = startTime.distance(to: .now())
            } else {
                elapsedTime = .nanoseconds(Int(DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds))
            }
            eventLogger.log(.requestCompleted(
                request: request,
                response: response,
                elapsedTime: elapsedTime.toMilliseconds()))
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
        let statusCode = result.response?.statusCode ?? (result.error as NSError?)?.code ?? 0
        let errorType = Restler.ErrorType(statusCode: statusCode) ?? .unknownError
        return Restler.Error.request(type: errorType, response: Restler.Response(result))
    }
}
