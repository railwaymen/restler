import XCTest
@testable import Restler

final class RestlerDownloadTaskMock {
    
    // MARK: - RestlerDownloadTaskType
    var progressReturnValue: Progress = .init()
    
    var downloadProgressReturnValue: Double = 0
    
    var stateReturnValue: URLSessionTask.State = .suspended
    
    private(set) var resumeParams: [ResumeParams] = []
    struct ResumeParams {}
    
    private(set) var cancelParams: [CancelParams] = []
    struct CancelParams {
        let completionHandler: ((Data?) -> Void)?
    }
    
    private(set) var suspendParams: [SuspendParams] = []
    struct SuspendParams {}
}

// MARK: - RestlerDownloadTaskType
extension RestlerDownloadTaskMock: RestlerDownloadTaskType {
    var progress: Progress {
        self.progressReturnValue
    }
    
    var downloadProgress: Double {
        self.downloadProgressReturnValue
    }
    
    var state: URLSessionTask.State {
        self.stateReturnValue
    }
    
    func resume() {
        self.resumeParams.append(ResumeParams())
    }
    
    func cancel() {
        self.cancelParams.append(CancelParams(completionHandler: nil))
    }
    
    func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void) {
        self.cancelParams.append(CancelParams(completionHandler: completionHandler))
    }
    
    func suspend() {
        self.suspendParams.append(SuspendParams())
    }
}
