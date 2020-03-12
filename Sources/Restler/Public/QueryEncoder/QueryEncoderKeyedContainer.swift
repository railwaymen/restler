import Foundation

extension Restler.QueryEncoder {
    public class KeyedContainer<Key: CodingKey>: RestlerQueryEncoderContainerType {
        internal var dictionary: [String: String] = [:]
        
        // MARK: - Public
        public func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.restlerStringValue
        }
    }
}

// MARK: - RestlerQueryContainerType
extension Restler.QueryEncoder.KeyedContainer: StringDictionaryRepresentable {}
