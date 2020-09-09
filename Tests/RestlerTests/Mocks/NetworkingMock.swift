import Foundation
#if canImport(Combine)
import Combine
#endif
@testable import Restler

final class NetworkingMock {
    
    // MARK: - NetworkingType
    var makeRequestReturnValue: Restler.Task = .init(task: URLSessionDataTaskMock())
    private(set) var makeRequestParams: [MakeRequestParams] = []
    struct MakeRequestParams {
        let urlRequest: URLRequest
        let completion: DataCompletion
    }
    
    var buildRequestReturnValue: URLRequest?
    private(set) var buildRequestParams: [BuildRequestParams] = []
    struct BuildRequestParams {
        let url: URL
        let method: HTTPMethod
        let header: Restler.Header
        let customRequestModification: ((inout URLRequest) -> Void)?
    }
    
    private(set) var getPublisherParams: [GetPublisherParams] = []
    struct GetPublisherParams {
        let urlRequest: URLRequest
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    func makeRequest(
        urlRequest: URLRequest,
        eventLogger: EventLoggerLogging,
        completion: @escaping DataCompletion
    ) -> Restler.Task {
        self.makeRequestParams.append(MakeRequestParams(
            urlRequest: urlRequest,
            completion: completion))
        return self.makeRequestReturnValue
    }
    
    func buildRequest(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?
    ) -> URLRequest? {
        self.buildRequestParams.append(BuildRequestParams(
            url: url,
            method: method,
            header: header,
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
}
