import Foundation

extension Restler {
    open class ErrorParser: RestlerErrorParserType {
        private var decodingErrors: [RestlerErrorDecodable.Type] = []
        
        // MARK: - Initialization
        internal init(decodingErrors: [RestlerErrorDecodable.Type] = []) {
            self.decodingErrors = decodingErrors
        }
        
        // MARK: - Open
        open func decode<T>(_ type: T.Type) where T: RestlerErrorDecodable {
            self.decodingErrors.append(type)
        }
        
        open func stopDecoding<T>(_ type: T.Type) where T: RestlerErrorDecodable {
            self.decodingErrors.removeAll { $0 == type }
        }
        
        open func copy() -> RestlerErrorParserType {
            return ErrorParser(decodingErrors: self.decodingErrors)
        }
        
        open func parse(_ error: Swift.Error) -> Swift.Error {
            guard case let .request(_, response) = error as? Restler.Error else { return error }
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
