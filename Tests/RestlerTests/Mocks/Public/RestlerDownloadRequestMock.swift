import XCTest
@testable import Restler

final class RestlerDownloadRequestMock {
    
    // MARK: - RestlerDownloadRequestType
    var subscribeReturnValue: RestlerDownloadTaskMock = .init()
    private(set) var subscribeParams: [SubscribeParams] = []
    struct SubscribeParams {
        let onProgress: ((Progress) -> Void)?
        let onSuccess: ((URL) -> Void)?
        let onError: ((Restler.Error) -> Void)?
        let onCompletion: ((Result<URL, Restler.Error>) -> Void)?
    }
}

// MARK: - RestlerDownloadRequestType
extension RestlerDownloadRequestMock: RestlerDownloadRequestType {
    func subscribe(
        onProgress: ((Progress) -> Void)?,
        onSuccess: ((URL) -> Void)?,
        onError: ((Restler.Error) -> Void)?,
        onCompletion: ((Result<URL, Restler.Error>) -> Void)?
    ) -> RestlerDownloadTaskType? {
        self.subscribeParams.append(
            SubscribeParams(
                onProgress: onProgress,
                onSuccess: onSuccess,
                onError: onError,
                onCompletion: onCompletion))
        return nil
    }
}
