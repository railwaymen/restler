import Foundation

extension Restler.QueryEncoder {
    public class KeyedContainer<Key: CodingKey>: RestlerQueryEncoderContainerType {
        internal var tuples: [(key: String, value: String)] = []
        
        // MARK: - Public
        public func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws {
            if let stringValue = value?.restlerStringValue {
                self.tuples.append((key.stringValue, stringValue))
            } else {
                self.tuples.removeAll(where: { $0.key == key.stringValue })
            }
        }
    }
}

// MARK: - RestlerQueryContainerType
extension Restler.QueryEncoder.KeyedContainer: QueryItemsRepresentable {}
