import Foundation

extension Restler {
    public class QueryEncoder: RestlerQueryEncoderType {
        private let jsonEncoder: RestlerJSONEncoderType
        
        private var containers: [QueryItemsRepresentable] = []
        
        // MARK: - Initialization
        init(jsonEncoder: RestlerJSONEncoderType) {
            self.jsonEncoder = jsonEncoder
        }
        
        // MARK: - Public functions
        public func container<Key: CodingKey>(using _: Key.Type) -> KeyedContainer<Key> {
            let container = KeyedContainer<Key>(jsonEncoder: self.jsonEncoder)
            self.containers.append(container)
            return container
        }
        
        public func stringKeyedContainer() -> StringKeyedContainer {
            let container = StringKeyedContainer(jsonEncoder: self.jsonEncoder)
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
