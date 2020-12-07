import Foundation
#if canImport(Combine)
import Combine
#endif

typealias DataResult = Result<Data?, Error>
typealias DataCompletion = (DataResult) -> Void

protocol NetworkingType: class {
    func buildRequest(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?
    ) -> URLRequest?
    
    func makeRequest(
        urlRequest: URLRequest,
        urlSession: URLSessionType?,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion
    ) -> Restler.Task
    
    func downloadRequest(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging,
        resumeData: Data?,
        progressHandler: @escaping (RestlerDownloadTaskType) -> Void,
        completionHandler: @escaping (Result<URL, Restler.Error>) -> Void
    ) -> RestlerDownloadTaskType
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func getPublisher(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging
    ) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>
    #endif
}

final class Networking: NSObject {
    private let session: URLSessionType
    private let customDownloadSession: URLSessionType?
    
    private lazy var defaultDownloadSession: URLSessionType = URLSession(
        configuration: .default,
        delegate: self,
        delegateQueue: nil)
    
    private var downloadSession: URLSessionType {
        self.customDownloadSession ?? self.defaultDownloadSession
    }
    
    private var downloadTaskCompletionHandlers: [Int: (Result<URL, Restler.Error>) -> Void] = [:]
    private var downloadTaskProgressHandlers: [Int: () -> Void] = [:]
    
    // MARK: - Initialization
    init(
        dataSession: URLSessionType = URLSession.shared,
        customDownloadSession: URLSessionType? = nil
    ) {
        self.session = dataSession
        self.customDownloadSession = customDownloadSession
    }
}

// MARK: - NetworkingType
extension Networking: NetworkingType {
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
    
    func makeRequest(
        urlRequest: URLRequest,
        urlSession: URLSessionType?,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion
    ) -> Restler.Task {
        Restler.Task(
            task: self.runDataTask(
                request: urlRequest,
                urlSession: urlSession,
                eventLogger: eventLogger,
                completion: completion))
    }
    
    func downloadRequest(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging,
        resumeData: Data?,
        progressHandler: @escaping (RestlerDownloadTaskType) -> Void,
        completionHandler: @escaping (Result<URL, Restler.Error>) -> Void
    ) -> RestlerDownloadTaskType {
        let task = Restler.DownloadTask(
            urlTask: self.runDownloadTask(
                request: urlRequest,
                eventLogger: eventLogger,
                resumeData: resumeData))
        self.downloadTaskProgressHandlers[task.id] = { progressHandler(task) }
        self.downloadTaskCompletionHandlers[task.id] = completionHandler
        task.resume()
        return task
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

// MARK: - URLSessionDelegate
extension Networking: URLSessionDelegate {}

// MARK: - URLSessionTaskDelegate
extension Networking: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let handler = self.downloadTaskCompletionHandlers[task.taskIdentifier] else { return }
        guard let systemError = task.error ?? error else { return }
        let response = task.response as? HTTPURLResponse
        let statusCode = response?.statusCode
            ?? (systemError as NSError?)?.code
            ?? 0
        let errorType = Restler.ErrorType(statusCode: statusCode) ?? .unknownError
        let error = Restler.Error.request(
            type: errorType,
            response: Restler.Response(
                data: nil,
                response: response,
                error: systemError))
        handler(.failure(error))
        self.downloadTaskProgressHandlers.removeValue(forKey: task.taskIdentifier)
        self.downloadTaskCompletionHandlers.removeValue(forKey: task.taskIdentifier)
    }
}

// MARK: - URLSessionDownloadDelegate
extension Networking: URLSessionDownloadDelegate {
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        guard let handler = self.downloadTaskProgressHandlers[downloadTask.taskIdentifier] else { return }
        handler()
    }
    
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        guard let handler = self.downloadTaskCompletionHandlers[downloadTask.taskIdentifier] else { return }
        handler(.success(location))
        self.downloadTaskProgressHandlers.removeValue(forKey: downloadTask.taskIdentifier)
        self.downloadTaskCompletionHandlers.removeValue(forKey: downloadTask.taskIdentifier)
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
    
    private func runDataTask(
        request: URLRequest,
        urlSession: URLSessionType?,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion
    ) -> URLSessionDataTaskType {
        let session = urlSession ?? self.session
        let startTime: DispatchTime = .now()
        let task = session.dataTask(with: request) { response in
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
    
    private func runDownloadTask(
        request: URLRequest,
        eventLogger: EventLoggerLogging,
        resumeData: Data?
    ) -> URLSessionDownloadTaskType {
        if let data = resumeData {
            return self.downloadSession.downloadTask(withResumeData: data)
        } else {
            return self.downloadSession.downloadTask(with: request)
        }
    }
}
