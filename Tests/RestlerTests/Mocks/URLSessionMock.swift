import Foundation
@testable import Restler

class URLSessionMock {
    
    // MARK: - URLSessionType
    var dataTaskReturnValue: URLSessionDataTaskMock = URLSessionDataTaskMock()
    private(set) var dataTaskParams: [DataTaskParams] = []
    struct DataTaskParams {
        let request: URLRequest
        let completion: (HTTPRequestResponse) -> Void
    }
}

// MARK: - URLSessionType
extension URLSessionMock: URLSessionType {
    func dataTask(with request: URLRequest, completion: @escaping (HTTPRequestResponse) -> Void) -> URLSessionDataTaskType {
        self.dataTaskParams.append(DataTaskParams(request: request, completion: completion))
        return self.dataTaskReturnValue
    }
}
