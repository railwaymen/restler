import Foundation

protocol DictionaryEncoderType: class {
    func encode<E>(_ object: E) throws -> [String: String?] where E: Encodable
}

class DictionaryEncoder: DictionaryEncoderType {
    private let encoder: RestlerJSONEncoderType
    private let serialization: JSONSerializationType
    
    // MARK: - Initialization
    init(
        encoder: RestlerJSONEncoderType,
        serialization: JSONSerializationType
    ) {
        self.encoder = encoder
        self.serialization = serialization
    }
    
    // MARK: - Internal
    func encode<E>(_ object: E) throws -> [String: String?] where E: Encodable {
        let dictionary: [String: Any] = try self.encode(object)
        return dictionary.mapValues { value -> String? in
            if let string = value as? String {
                return string
            } else if let number = value as? NSNumber {
                return number.stringValue
            }
            return nil
        }.filter { $0.value != nil }
    }
}

// MARK: - Private
extension DictionaryEncoder {
    private func encode<E>(_ object: E) throws -> [String: Any] where E: Encodable {
        let data = try self.encoder.encode(object)
        let json = try self.serialization.jsonObject(with: data, options: .allowFragments)
        guard let jsonDictionary = json as? [String: Any] else {
            throw Restler.Error.common(
                type: .internalFrameworkError,
                base: EncodingError.invalidValue(
                    E.self,
                    EncodingError.Context.init(
                        codingPath: [],
                        debugDescription: "Encoding to dictionary has failed")))
        }
        return jsonDictionary
    }
    
}
