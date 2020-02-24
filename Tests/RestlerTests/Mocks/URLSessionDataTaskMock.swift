import Foundation
@testable import Restler

class URLSessionDataTaskMock {
    
    // MARK: - URLSessionDataTaskType
    private(set) var resumeParams: [ResumeParams] = []
    struct ResumeParams {}
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTaskMock: URLSessionDataTaskType {
    func resume() {
        self.resumeParams.append(ResumeParams())
    }
}
