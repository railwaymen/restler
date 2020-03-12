import Foundation

extension Restler.QueryEncoder {
    public class StringKeyedContainer: RestlerQueryEncoderContainerType {
        public typealias Key = String
        
        internal var dictionary: [String: String] = [:]
        
        // MARK: - Public
        public func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws {
            self.dictionary[key] = value?.restlerStringValue
        }

    }
}

// MARK: - RestlerQueryContainerType
extension Restler.QueryEncoder.StringKeyedContainer: StringDictionaryRepresentable {}
