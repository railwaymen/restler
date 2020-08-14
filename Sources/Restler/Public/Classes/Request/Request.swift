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
        ///   Restler.Task interface for managing the task (e.g. cancelling it) if the task is created properly.
        ///   Returns nil if the task couldn't be created because of encoding errors.
        ///
        @discardableResult
        open func start() -> RestlerTaskType? {
            return nil
        }
    }
}
