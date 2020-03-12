import Foundation

extension Restler {
    public class QueryEncoder: RestlerQueryEncoderType {
        private var containers: [StringDictionaryRepresentable] = []
        
        // MARK: - Public functions
        public func container<Key: CodingKey>(using: Key.Type) -> KeyedContainer<Key> {
            let container = KeyedContainer<Key>()
            self.containers.append(container)
            return container
        }
        
        public func stringKeyedContainer() -> StringKeyedContainer {
            let container = StringKeyedContainer()
            self.containers.append(container)
            return container
        }
        
        public func encode<T: RestlerQueryEncodable>(_ object: T) throws -> [String: String] {
            try object.encodeToQuery(using: self)
            return self.containers.reduce(into: [String: String]()) { result, container in
                result.merge(container.dictionary, uniquingKeysWith: { _, rhs in return rhs })
            }
        }
    }
}
