import XCTest
@testable import RestlerCore

final class URLSessionDownloadTaskMock {
    
    // MARK: - URLSessionDownloadTaskType
    var taskIdentifierReturnValue: Int = 0
    var progressReturnValue: Progress = .init()
    // swiftlint:disable:next identifier_name
    var countOfBytesClientExpectsToReceiveReturnValue: Int64 = 0
    var countOfBytesExpectedToReceiveReturnValue: Int64 = 0
    var countOfBytesReceivedReturnValue: Int64 = 0
    var stateReturnValue: URLSessionTask.State = .suspended
    
    private(set) var resumeParams: [ResumeParams] = []
    struct ResumeParams {}
    
    private(set) var suspendParams: [SuspendParams] = []
    struct SuspendParams {}
    
    private(set) var cancelParams: [CancelParams] = []
    struct CancelParams {}
    
    private(set) var cancelByProducingResumeDataParams: [CancelByProducingResumeDataParams] = []
    struct CancelByProducingResumeDataParams {
        let completionHandler: (Data?) -> Void
    }
}

// MARK: - URLSessionDownloadTaskType
extension URLSessionDownloadTaskMock: URLSessionDownloadTaskType {
    var taskIdentifier: Int {
        taskIdentifierReturnValue
    }
    
    var progress: Progress {
        progressReturnValue
    }
    
    var countOfBytesClientExpectsToReceive: Int64 {
        countOfBytesClientExpectsToReceiveReturnValue
    }
    
    var countOfBytesExpectedToReceive: Int64 {
        countOfBytesExpectedToReceiveReturnValue
    }
    
    var countOfBytesReceived: Int64 {
        countOfBytesReceivedReturnValue
    }
    
    var state: URLSessionTask.State {
        stateReturnValue
    }
    
    func resume() {
        resumeParams.append(.init())
    }
    
    func suspend() {
        suspendParams.append(.init())
    }
    
    func cancel() {
        cancelParams.append(.init())
    }
    
    func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void) {
        cancelByProducingResumeDataParams.append(.init(completionHandler: completionHandler))
    }
}
