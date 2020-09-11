import Foundation
@testable import Restler

final class URLSessionMock {
    
    // MARK: - URLSessionType
    var dataTaskReturnValue: URLSessionDataTaskMock = URLSessionDataTaskMock()
    private(set) var dataTaskParams: [DataTaskParams] = []
    struct DataTaskParams {
        let request: URLRequest
        let completion: (HTTPRequestResponse) -> Void
    }
    
    private(set) var dataTaskPublisherParams: [DataTaskPublisherParams] = []
    struct DataTaskPublisherParams {
        let request: URLRequest
    }
}

// MARK: - URLSessionType
extension URLSessionMock: URLSessionType {
    func dataTask(with request: URLRequest, completion: @escaping (HTTPRequestResponse) -> Void) -> URLSessionDataTaskType {
        self.dataTaskParams.append(DataTaskParams(request: request, completion: completion))
        return self.dataTaskReturnValue
    }
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        self.dataTaskPublisherParams.append(DataTaskPublisherParams(request: request))
        return URLSession.shared.dataTaskPublisher(for: request)
    }
    #endif
}
