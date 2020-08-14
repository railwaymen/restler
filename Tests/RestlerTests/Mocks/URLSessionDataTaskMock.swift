import Foundation
@testable import Restler

final class URLSessionDataTaskMock {
    
    // MARK: - URLSessionDataTaskType
    var taskIdentifierReturnValue: Int = 0
    
    var stateReturnValue: URLSessionTask.State = .running
    
    private(set) var cancelParams: [CancelParams] = []
    struct CancelParams {}
    
    private(set) var suspendParams: [SuspendParams] = []
    struct SuspendParams {}
    
    private(set) var resumeParams: [ResumeParams] = []
    struct ResumeParams {}
}

// MARK: - URLSessionDataTaskType
extension URLSessionDataTaskMock: URLSessionDataTaskType {
    var taskIdentifier: Int {
        return self.taskIdentifierReturnValue
    }
    
    var state: URLSessionTask.State {
        return self.stateReturnValue
    }
    
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
