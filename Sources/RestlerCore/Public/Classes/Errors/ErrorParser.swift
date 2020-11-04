import Foundation

extension Restler {
    public struct ErrorParser: RestlerErrorParserType {
        public var decodingErrors: [RestlerErrorDecodable.Type] = []
        
        // MARK: - Initialization
        public init(decodingErrors: [RestlerErrorDecodable.Type] = []) {
            self.decodingErrors = decodingErrors
        }
        
        // MARK: - Public
        public mutating func decode<T>(_ type: T.Type) where T: RestlerErrorDecodable {
            self.decodingErrors.append(type)
        }
        
        public mutating func stopDecoding<T>(_ type: T.Type) where T: RestlerErrorDecodable {
            self.decodingErrors.removeAll { $0 == type }
        }
        
        public func parse(_ error: Swift.Error) -> Swift.Error {
            guard case let .request(_, response) = error as? Restler.Error else { return error }
            let errors = self.decodingErrors.compactMap { $0.init(response: response) }
            if errors.isEmpty {
                return error
            } else if let first = errors.first, errors.count == 1 {
                return first
            }
            return Restler.Error.multiple(errors.map { error in
                return Restler.Error.common(type: .unknownError, base: error)
            })
        }
    }
}
