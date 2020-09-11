import Foundation

extension Restler {
    /// An API request.
    open class Request<D>: RestlerRequest {
        public init() {}
        
        /// Sets handler called on successful request response.
        ///
        /// Called just before `onCompletion` handler.
        ///
        /// - Parameters:
        ///   - handler: A handler called on the request `.success` completion.
        ///
        /// - Returns: `self` for chaining.
        ///
        @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
        open func onSuccess(_ handler: @escaping (D) -> Void) -> Self {
            return self
        }
        
        /// Sets handler called on failed request response.
        ///
        /// Called just before `onCompletion` handler.
        ///
        /// - Parameters:
        ///   - handler: A handler called on the request `.failure` completion.
        ///
        /// - Returns: `self` for chaining.
        ///
        @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
        open func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self {
            return self
        }
        
        /// Sets handler called on the completion of the request.
        ///
        /// Called at the very end of the request.
        ///
        /// - Parameters:
        ///   - handler: A handler called on the request completion.
        ///
        /// - Returns: `self` for chaining.
        ///
        @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
        open func onCompletion(_ handler: @escaping (Result<D, Swift.Error>) -> Void) -> Self {
            return self
        }
        
        /// Starts the request.
        ///
        /// This function have to be called to start the request.
        ///
        /// - Warning:
        ///   If the encoding of parameters is at 100% successful the returned nil
        ///    means that Restler internal error have occured.
        ///   Please contact the developers of the framework in this case.
        ///
        /// - Returns:
        ///   `Restler.Task` interface for managing the task (e.g. cancelling it) if the task is created properly.
        ///   Returns `nil` if the task couldn't be created because of encoding errors.
        ///
        @discardableResult
        @available(*, deprecated, message: "Use `subscribe(onSuccess:onFailure:onCompletion:)`")
        open func start() -> RestlerTaskType? {
            return nil
        }
        
        /// Sets the request to use the provided `URLSession` instead of the default one.
        ///
        /// - Parameters:
        ///   - session: A `URLSession` that will perform the built task. If not set, `shared` will be used.
        ///
        /// - Returns: `self` for chaining.
        ///
        open func using(session: URLSession) -> Self {
            return self
        }
        
        /// Runs networking task with specified handlers at its completion.
        ///
        /// - Parameters:
        ///   - onSuccess: A handler called on successful response.
        ///   - object: A decoded object.
        ///
        ///   - onFailure: A handler called when request has failed.
        ///   - error: An error that occured during the request.
        ///
        ///   - onCompletion: A handler called when request has finished.
        ///   - result: A result of networking request with a decoded object or an error.
        ///
        /// - Returns:
        ///   `Restler.Task` interface for managing the task (e.g. cancelling it) if the task is created properly.
        ///   Returns `nil` if the task couldn't be created because of encoding errors.
        ///
        @discardableResult
        open func subscribe(
            onSuccess: ((_ object: D) -> Void)? = nil,
            onFailure: ((_ error: Swift.Error) -> Void)? = nil,
            onCompletion: ((_ result: Result<D, Swift.Error>) -> Void)? = nil
        ) -> RestlerTaskType? {
            return nil
        }
    }
}
