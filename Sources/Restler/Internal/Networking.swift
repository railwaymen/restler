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
    func getPublisher(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging
    ) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
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
    func getPublisher(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging
    ) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        var startTime: DispatchTime?
        return self.session.dataTaskPublisher(for: urlRequest)
            .handleEvents(
                receiveSubscription: { _ in startTime = .now() },
                receiveOutput: { data, response in
                    let elapsedTime: Milliseconds = DispatchTime.now().since(startTime ?? .now()).toMilliseconds()
                    let httpResponse = HTTPRequestResponse(data: data, response: response as? HTTPURLResponseType, error: nil)
                    eventLogger.log(.requestCompleted(request: urlRequest, response: httpResponse, elapsedTime: elapsedTime))
            },
                receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    let elapsedTime: Milliseconds = DispatchTime.now().since(startTime ?? .now()).toMilliseconds()
                    let httpResponse = HTTPRequestResponse(data: nil, response: nil, error: error)
                    eventLogger.log(.requestCompleted(request: urlRequest, response: httpResponse, elapsedTime: elapsedTime))
            })
            .eraseToAnyPublisher()
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
            let elapsedTime: Milliseconds = DispatchTime.now().since(startTime).toMilliseconds()
            eventLogger.log(.requestCompleted(
                request: request,
                response: response,
                elapsedTime: elapsedTime))
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
