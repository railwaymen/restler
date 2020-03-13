import Foundation

extension Restler.QueryEncoder {
    public class StringKeyedContainer: RestlerQueryEncoderContainerType {
        public typealias Key = String
        
        internal var tuples: [(key: String, value: String)] = []
        
        // MARK: - Public
        public func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws {
            if let stringValue = value?.restlerStringValue {
                self.tuples.append((key, stringValue))
            } else {
                self.removeAll(for: key)
            }
        }
        
        public func encode(_ value: [RestlerStringEncodable]?, forKey key: String) throws {
            if let array = value {
                let queries: [(String, String)] = array.map { (key + "[]", $0.restlerStringValue) }
                self.tuples.append(contentsOf: queries)
            } else {
                self.removeAll(for: key)
            }
        }
        
        public func encode(_ value: [String : RestlerStringEncodable]?, forKey key: String) throws {
            if let dictionary = value {
                let queries: [(String, String)] = dictionary.map { (key + "[\($0.key)]", $0.value.restlerStringValue) }
                self.tuples.append(contentsOf: queries)
            } else {
                self.removeAll(for: key)
            }
        }
    }
}

// MARK: - RestlerQueryContainerType
extension Restler.QueryEncoder.StringKeyedContainer: QueryItemsRepresentable {}

// MARK: - Private
extension Restler.QueryEncoder.StringKeyedContainer {
    private func removeAll(for key: Key) {
        self.tuples.removeAll { $0.key == key }
    }
}
