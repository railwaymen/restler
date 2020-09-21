import Foundation

public protocol RestlerDownloadRequestType: class {
    func subscribe(
        onProgress: ((Progress) -> Void)?,
        onSuccess: ((URL) -> Void)?,
        onError: ((Restler.Error) -> Void)?,
        onCompletion: ((Result<URL, Restler.Error>) -> Void)?
    ) -> RestlerDownloadTaskType?
}

extension RestlerDownloadRequestType {
    public func subscribe(
        onProgress: ((Progress) -> Void)? = nil,
        onSuccess: ((URL) -> Void)? = nil,
        onError: ((Restler.Error) -> Void)? = nil,
        onCompletion: ((Result<URL, Restler.Error>) -> Void)? = nil
    ) -> RestlerDownloadTaskType? {
        self.subscribe(
            onProgress: onProgress,
            onSuccess: onSuccess,
            onError: onError,
            onCompletion: onCompletion)
    }
}

extension Restler {
    final public class DownloadRequest: RestlerDownloadRequestType {
        private let dependencies: RequestDependencies
        
        private var onProgressHandler: ((Progress) -> Void)?
        private var onSuccessHandler: ((URL) -> Void)?
        private var onErrorHandler: ((Error) -> Void)?
        private var onCompletionHandler: ((Result<URL, Error>) -> Void)?
        
        // MARK: - Initialization
        init(dependencies: RequestDependencies) {
            self.dependencies = dependencies
        }
        
        // MARK: - Public
        public func subscribe(
            onProgress: ((Progress) -> Void)?,
            onSuccess: ((URL) -> Void)?,
            onError: ((Restler.Error) -> Void)?,
            onCompletion: ((Result<URL, Restler.Error>) -> Void)?
        ) -> RestlerDownloadTaskType? {
            if let onProgress = onProgress {
                self.onProgressHandler = onProgress
            }
            if let onSuccess = onSuccess {
                self.onSuccessHandler = onSuccess
            }
            if let onError = onError {
                self.onErrorHandler = onError
            }
            if let onCompletion = onCompletion {
                self.onCompletionHandler = onCompletion
            }
            
            return nil
        }
    }
}
