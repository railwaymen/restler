import Foundation

protocol RestlerRequestInternal: class {
    var dispatchQueueManager: DispatchQueueManagerType { get }
}

extension RestlerRequestInternal {
    func mainThreadClosure<T>(of closure: @escaping (T) -> Void) -> (T) -> Void {
        return { [dispatchQueueManager] result in
            dispatchQueueManager.perform(on: .main, .async) {
                closure(result)
            }
        }
    }
    
    func errorsDecodeHandler(decodingErrors: [RestlerErrorDecodable.Type]) -> (Error) -> Error {
        return { error in
            guard case let .request(_, response)  = error as? Restler.Error else { return error }
            let errors = decodingErrors.compactMap { $0.init(response: response) }
            if errors.isEmpty {
                return error
            } else if let first = errors.first, errors.count == 1 {
                return first
            }
            return Restler.Error.multiple(errors.map { error in
                if let restlerError = error as? Restler.Error {
                    return restlerError
                }
                return Restler.Error.common(type: .unknownError, base: error)
            })
            
        }
    }
}
