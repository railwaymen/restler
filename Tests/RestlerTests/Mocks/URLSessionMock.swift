import Foundation
@testable import RestlerCore

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
    
    var downloadTaskWithRequestReturnValue: URLSessionDownloadTaskMock = .init()
    private(set) var downloadTaskWithRequestParams: [DownloadTaskWithRequestParams] = []
    struct DownloadTaskWithRequestParams {
        let request: URLRequest
    }
    
    var downloadTaskWithResumeDataReturnValue: URLSessionDownloadTaskMock = .init()
    private(set) var downloadTaskWithResumeDataParams: [DownloadTaskWithResumeDataParams] = []
    struct DownloadTaskWithResumeDataParams {
        let resumeData: Data
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
    
    func downloadTask(with request: URLRequest) -> URLSessionDownloadTaskType {
        downloadTaskWithRequestParams.append(.init(request: request))
        return downloadTaskWithRequestReturnValue
    }
    
    func downloadTask(withResumeData resumeData: Data) -> URLSessionDownloadTaskType {
        downloadTaskWithResumeDataParams.append(.init(resumeData: resumeData))
        return downloadTaskWithResumeDataReturnValue
    }
}
