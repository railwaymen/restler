import Foundation

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
extension Restler.QueryEncoder.StringKeyedContainer: StringDictionaryRepresentable {}
