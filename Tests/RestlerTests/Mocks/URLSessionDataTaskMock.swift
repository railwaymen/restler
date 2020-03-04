import Foundation
@testable import Restler

class URLSessionDataTaskMock {
    
    // MARK: - URLSessionDataTaskType
    private(set) var cancelParams: [CancelParams] = []
    struct CancelParams {}
    
    private(set) var suspendParams: [SuspendParams] = []
    struct SuspendParams {}
    
    private(set) var resumeParams: [ResumeParams] = []
    struct ResumeParams {}
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTaskMock: URLSessionDataTaskType {
    func cancel() {
        self.cancelParams.append(CancelParams())
    }
    
    func suspend() {
        self.suspendParams.append(SuspendParams())
    }
    
    func resume() {
        self.resumeParams.append(ResumeParams())
    }
}
