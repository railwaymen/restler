import Foundation

public protocol RestlerQueryEncoderType {
    func container<Key: CodingKey>(using: Key.Type) -> Restler.QueryEncoder.KeyedContainer<Key>
    func stringKeyedContainer() -> Restler.QueryEncoder.StringKeyedContainer
    func encode<Key: RestlerQueryEncodable>(_ object: Key) throws -> [String: String]
}

public protocol RestlerQueryEncoderContainerType {
    associatedtype Key
    func encode(_ value: Decimal?, forKey key: Key) throws
    func encode(_ value: Double?, forKey key: Key) throws
    func encode(_ value: Float?, forKey key: Key) throws
    func encode(_ value: Int?, forKey key: Key) throws
    func encode(_ value: Int8?, forKey key: Key) throws
    func encode(_ value: Int16?, forKey key: Key) throws
    func encode(_ value: Int32?, forKey key: Key) throws
    func encode(_ value: Int64?, forKey key: Key) throws
    func encode(_ value: UInt?, forKey key: Key) throws
    func encode(_ value: UInt8?, forKey key: Key) throws
    func encode(_ value: UInt16?, forKey key: Key) throws
    func encode(_ value: UInt32?, forKey key: Key) throws
    func encode(_ value: UInt64?, forKey key: Key) throws
    func encode(_ value: String?, forKey key: Key) throws
    func encode(_ value: UUID?, forKey key: Key) throws
    func encode(_ value: URL?, forKey key: Key) throws
    func encode(_ value: Bool?, forKey key: Key) throws
}

internal protocol StringDictionaryRepresentable {
    var dictionary: [String: String] { get }
}

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

// MARK: - KeyedContainer
extension Restler.QueryEncoder {
    public class KeyedContainer<Key: CodingKey>: RestlerQueryEncoderContainerType {
        internal var dictionary: [String: String] = [:]
        
        // MARK: - Public
        public func encode(_ value: Decimal?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Double?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Float?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int8?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int16?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int32?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Int64?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt8?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt16?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt32?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: UInt64?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: String?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value
        }
        
        public func encode(_ value: UUID?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: URL?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
        
        public func encode(_ value: Bool?, forKey key: Key) throws {
            self.dictionary[key.stringValue] = value?.description
        }
    }
}

extension Restler.QueryEncoder {
    public class StringKeyedContainer: RestlerQueryEncoderContainerType {
        public typealias Key = String
        
        internal var dictionary: [String: String] = [:]
        
        // MARK: - Public
        public func encode(_ value: Decimal?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Double?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Float?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Int?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Int8?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Int16?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Int32?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Int64?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: UInt?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: UInt8?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: UInt16?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: UInt32?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: UInt64?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: String?, forKey key: Key) throws {
            self.dictionary[key] = value
        }
        
        public func encode(_ value: UUID?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: URL?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
        
        public func encode(_ value: Bool?, forKey key: Key) throws {
            self.dictionary[key] = value?.description
        }
    }
}

// MARK: - RestlerQueryContainerType
extension Restler.QueryEncoder.KeyedContainer: StringDictionaryRepresentable {}
extension Restler.QueryEncoder.StringKeyedContainer: StringDictionaryRepresentable {}
