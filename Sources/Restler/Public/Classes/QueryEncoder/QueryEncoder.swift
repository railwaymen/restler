import Foundation

extension Restler {
    public class QueryEncoder: RestlerQueryEncoderType {
        private var containers: [QueryItemsRepresentable] = []
        
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
        
        public func encode<T: RestlerQueryEncodable>(_ object: T) throws -> [URLQueryItem] {
            try object.encodeToQuery(using: self)
            return self.containers.reduce(into: [URLQueryItem]()) { result, container in
                let queryItems = container.tuples.map { key, value in
                    URLQueryItem(name: key, value: value)
                }
                result.append(contentsOf: queryItems)
            }
        }
    }
}
