import Foundation
import RestlerCore

final class RestlerRequestMock<T>: Restler.Request<T> {
    
    private(set) var onSuccessParams: [OnSuccessParams] = []
    struct OnSuccessParams {
        let handler: (T) -> Void
    }
    
    private(set) var onFailureParams: [OnFailureParams] = []
    struct OnFailureParams {
        let handler: (Error) -> Void
    }
    
    private(set) var onCompletionParams: [OnCompletionParams] = []
    struct OnCompletionParams {
        let handler: (Result<T, Error>) -> Void
    }
    
    var startReturnValue: RestlerTaskType?
    private(set) var startParams: [StartParams] = []
    struct StartParams {}
    
    var subscribeReturnValue: RestlerTaskType?
    private(set) var subscribeParams: [SubscribeParams] = []
    struct SubscribeParams {
        let onSuccess: ((T) -> Void)?
        let onFailure: ((Error) -> Void)?
        let onCompletion: ((Result<T, Error>) -> Void)?
    }
    
    // MARK: - Internal
    var lastSuccessHandler: ((T) -> Void)? {
        subscribeParams.last?.onSuccess
            ?? onSuccessParams.last?.handler
    }
    
    var lastFailureHandler: ((Error) -> Void)? {
        subscribeParams.last?.onFailure
            ?? onFailureParams.last?.handler
    }
    
    var lastCompletionHandler: ((Result<T, Error>) -> Void)? {
        subscribeParams.last?.onCompletion
            ?? onCompletionParams.last?.handler
    }
    
    // MARK: - Functions
    override func onSuccess(_ handler: @escaping (T) -> Void) -> Self {
        self.onSuccessParams.append(OnSuccessParams(handler: handler))
        return self
    }
    
    override func onFailure(_ handler: @escaping (Error) -> Void) -> Self {
        self.onFailureParams.append(OnFailureParams(handler: handler))
        return self
    }
    
    override func onCompletion(_ handler: @escaping (Result<T, Error>) -> Void) -> Self {
        self.onCompletionParams.append(OnCompletionParams(handler: handler))
        return self
    }
    
    override func start() -> RestlerTaskType? {
        self.startParams.append(StartParams())
        return self.startReturnValue
    }
    
    override func subscribe(
        onSuccess: ((T) -> Void)? = nil,
        onFailure: ((Error) -> Void)? = nil,
        onCompletion: ((Result<T, Error>) -> Void)? = nil
    ) -> RestlerTaskType? {
        self.subscribeParams.append(SubscribeParams(
            onSuccess: onSuccess,
            onFailure: onFailure,
            onCompletion: onCompletion))
        return self.subscribeReturnValue
    }
}
