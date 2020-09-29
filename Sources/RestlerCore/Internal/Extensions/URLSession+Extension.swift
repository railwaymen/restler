import Foundation

protocol URLSessionType: class {
    func dataTask(with request: URLRequest, completion: @escaping (HTTPRequestResponse) -> Void) -> URLSessionDataTaskType
    
    func downloadTask(with request: URLRequest) -> URLSessionDownloadTaskType
    func downloadTask(withResumeData resumeData: Data) -> URLSessionDownloadTaskType
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
    #endif
}

// MARK: - URLSessionType
extension URLSession: URLSessionType {
    func dataTask(with request: URLRequest, completion: @escaping (HTTPRequestResponse) -> Void) -> URLSessionDataTaskType {
        return self.dataTask(with: request) { (data, response, error) in
            completion(HTTPRequestResponse(data: data, response: response as? HTTPURLResponseType, error: error))
        }
    }
    
    func downloadTask(with request: URLRequest) -> URLSessionDownloadTaskType {
        self.downloadTask(with: request) as URLSessionDownloadTask
    }
    
    func downloadTask(withResumeData resumeData: Data) -> URLSessionDownloadTaskType {
        self.downloadTask(withResumeData: resumeData) as URLSessionDownloadTask
    }
}
