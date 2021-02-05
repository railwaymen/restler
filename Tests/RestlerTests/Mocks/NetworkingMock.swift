import Foundation
#if canImport(Combine)
import Combine
#endif
@testable import RestlerCore

final class NetworkingMock {
    
    // MARK: - NetworkingType
    var makeRequestReturnValue: Restler.Task = .init(task: URLSessionDataTaskMock())
    private(set) var makeRequestParams: [MakeRequestParams] = []
    struct MakeRequestParams {
        let urlRequest: URLRequest
        let urlSession: URLSessionType?
        let eventLogger: EventLoggerLogging
        let completion: DataCompletion
    }
    
    var buildRequestReturnValue: URLRequest?
    private(set) var buildRequestParams: [BuildRequestParams] = []
    struct BuildRequestParams {
        let requestData: RequestData
        let customRequestModification: ((inout URLRequest) -> Void)?
    }
    
    private(set) var getPublisherParams: [GetPublisherParams] = []
    struct GetPublisherParams {
        let urlRequest: URLRequest
    }
    
    var downloadRequestReturnValue: Restler.DownloadTask = .init(urlTask: URLSessionDownloadTaskMock())
    private(set) var downloadRequestParams: [DownloadRequestParams] = []
    struct DownloadRequestParams {
        let urlRequest: URLRequest
        let eventLogger: EventLoggerLogging
        let resumeData: Data?
        let progressHandler: (RestlerDownloadTaskType) -> Void
        let completionHandler: (Result<URL, Restler.Error>) -> Void
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    func makeRequest(
        urlRequest: URLRequest,
        urlSession: URLSessionType?,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion
    ) -> Restler.Task {
        self.makeRequestParams.append(
            MakeRequestParams(
                urlRequest: urlRequest,
                urlSession: urlSession,
                eventLogger: eventLogger,
                completion: completion))
        return self.makeRequestReturnValue
    }
    
    func buildRequest(
        requestData: RequestData,
        customRequestModification: ((inout URLRequest) -> Void)?
    ) -> URLRequest? {
        self.buildRequestParams.append(
            BuildRequestParams(
                requestData: requestData,
                customRequestModification: customRequestModification))
        return self.buildRequestReturnValue
    }
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func getPublisher(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging
    ) -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure> {
        self.getPublisherParams.append(GetPublisherParams(urlRequest: urlRequest))
        return URLSession.DataTaskPublisher(
            request: urlRequest,
            session: .shared)
        .eraseToAnyPublisher()
    }
    #endif
    
    func downloadRequest(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging,
        resumeData: Data?,
        progressHandler: @escaping (RestlerDownloadTaskType) -> Void,
        completionHandler: @escaping (Result<URL, Restler.Error>) -> Void
    ) -> RestlerDownloadTaskType {
        downloadRequestParams.append(
            .init(
                urlRequest: urlRequest,
                eventLogger: eventLogger,
                resumeData: resumeData,
                progressHandler: progressHandler,
                completionHandler: completionHandler))
        return downloadRequestReturnValue
    }
}
