import Foundation

protocol DictionaryEncoderType: class {
    func encodeToQuery<E>(_ object: E) throws -> [URLQueryItem] where E: RestlerQueryEncodable
}

class DictionaryEncoder: DictionaryEncoderType {
    private let encoder: RestlerQueryEncoderType
    
    // MARK: - Initialization
    init(
        encoder: RestlerQueryEncoderType
    ) {
        self.encoder = encoder
    }
    
    // MARK: - Internal
    func encodeToQuery<E>(_ object: E) throws -> [URLQueryItem] where E: RestlerQueryEncodable {
        return try self.encoder.encode(object)
    }
}
