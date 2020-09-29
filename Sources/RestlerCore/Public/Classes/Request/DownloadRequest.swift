import Foundation

public protocol RestlerDownloadRequestType: class {
    @discardableResult
    func subscribe(
        onProgress: ((RestlerDownloadTaskType) -> Void)?,
        onSuccess: ((URL) -> Void)?,
        onError: ((Restler.Error) -> Void)?,
        onCompletion: ((Result<URL, Restler.Error>) -> Void)?
    ) -> RestlerDownloadTaskType?
}

extension RestlerDownloadRequestType {
    @discardableResult
    public func subscribe(
        onProgress: ((RestlerDownloadTaskType) -> Void)? = nil,
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
        
        // MARK: - Initialization
        init(dependencies: RequestDependencies) {
            self.dependencies = dependencies
        }
        
        // MARK: - Public
        @discardableResult
        public func subscribe(
            onProgress: ((RestlerDownloadTaskType) -> Void)?,
            onSuccess: ((URL) -> Void)?,
            onError: ((Restler.Error) -> Void)?,
            onCompletion: ((Result<URL, Restler.Error>) -> Void)?
        ) -> RestlerDownloadTaskType? {
            guard let request = self.dependencies.urlRequest else { return nil }
            return self.dependencies.networking.downloadRequest(
                urlRequest: request,
                eventLogger: self.dependencies.eventLogger,
                progressHandler: { task in
                    self.performOnProperQueue {
                        onProgress?(task)
                    }
                },
                completionHandler: { result in
                    self.performOnProperQueue {
                        switch result {
                        case let .success(url):
                            onSuccess?(url)
                        case let .failure(error):
                            onError?(error)
                        }
                        onCompletion?(result)
                    }
                })
        }
    }
}

// MARK: - Private
extension Restler.DownloadRequest {
    private func performOnProperQueue(work: @escaping () -> Void) {
        guard let customQueue = self.dependencies.customDispatchQueue else {
            work()
            return
        }
        customQueue.async {
            work()
        }
    }
}
