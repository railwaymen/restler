import Foundation

public protocol RestlerQueryEncoderType {
    func container<T: CodingKey>(using: T.Type) -> Restler.QueryEncoder.Container<T>
    func encode<T: RestlerQueryEncodable>(_ object: T) throws -> [String: String]
}

internal protocol RestlerQueryContainerType {
    var dictionary: [String: String] { get }
}

extension Restler {
    public class QueryEncoder: RestlerQueryEncoderType {
        private var containers: [RestlerQueryContainerType] = []
        
        // MARK: - Public functions
        public func container<T: CodingKey>(using: T.Type) -> Container<T> {
            let container = Container<T>()
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

// MARK: - Container
extension Restler.QueryEncoder {
    public class Container<T: CodingKey> {
        internal var dictionary: [String: String] = [:]
        
        // Public
        public func encode(_ value: Decimal?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Double?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Float?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int8?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int16?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int32?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int64?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt8?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt16?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt32?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt64?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: String?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value
        }
        
        public func encode(_ value: UUID?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: URL?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Bool?, forKey key: T) throws {
            self.dictionary[key.stringValue] = value?.description
        }
    }
}

// MARK: - RestlerQueryContainerType
extension Restler.QueryEncoder.Container: RestlerQueryContainerType {}

// MARK: -
//extension Dictionary: RestlerQueryEncodable where Key == String, Value == String {
//    public func encodeToQuery(using encoder: Restler.QueryEncoder) throws {
//        var container = try encoder.container(using: <#T##CodingKey.Protocol#>)
//    }
//}
