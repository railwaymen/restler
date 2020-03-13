import Foundation

extension Restler.QueryEncoder {
    public class KeyedContainer<Key: CodingKey>: RestlerQueryEncoderContainerType {
        internal var tuples: [(key: String, value: String)] = []
        
        // MARK: - Public
        public func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws {
            if let stringValue = value?.restlerStringValue {
                self.tuples.append((key.stringValue, stringValue))
            } else {
                self.removeAll(for: key)
            }
        }
        
        public func encode(_ value: [RestlerStringEncodable]?, forKey key: Key) throws {
            if let array = value {
                let queries: [(String, String)] = array.map { (key.stringValue + "[]", $0.restlerStringValue) }
                self.tuples.append(contentsOf: queries)
            } else {
                self.removeAll(for: key)
            }
        }
        
        public func encode(_ value: [String : RestlerStringEncodable]?, forKey key: Key) throws {
            if let dictionary = value {
                let queries: [(String, String)] = dictionary.map { (key.stringValue + "[\($0.key)]", $0.value.restlerStringValue) }
                self.tuples.append(contentsOf: queries)
            } else {
                self.removeAll(for: key)
            }
        }
    }
}

// MARK: - RestlerQueryContainerType
extension Restler.QueryEncoder.KeyedContainer: QueryItemsRepresentable {}

// MARK: - Private
extension Restler.QueryEncoder.KeyedContainer {
    private func removeAll(for key: Key) {
        self.tuples.removeAll { $0.key == key.stringValue }
    }
}
