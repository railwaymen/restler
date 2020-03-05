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
            guard let request = error as? Restler.RequestError else { return error }
            let errors = decodingErrors.compactMap { $0.init(response: request.response) }
            if errors.isEmpty {
                return error
            } else if let first = errors.first, errors.count == 1 {
                return first
            } else {
                return Restler.MultipleErrors(errors: errors)
            }
        }
    }
}
