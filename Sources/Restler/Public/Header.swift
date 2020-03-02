import Foundation

extension Restler {
    public struct Header: Equatable {
        var raw: [String: String]
        
        // MARK: - Getters
        public var headers: [Key: String] {
            return self.raw.reduce(into: [Key: String]()) { $0[Key(rawValue: $1.key)] = $1.value }
        }
        
        // MARK: - Initialization
        public init(_ header: [Key: String] = [:]) {
            self.raw = header.reduce(into: [String: String]()) { $0[$1.key.rawValue] = $1.value }
        }
        
        init(raw: [String: String]) {
            self.raw = raw
        }
        
        // MARK: - Subscripts
        
        public subscript(_ key: Key) -> String? {
            get {
                return self.raw[key.rawValue]
            }
            set {
                self.raw[key.rawValue] = newValue
            }
        }
        
        // MARK: - Mutating
        
        public mutating func set(_ value: String?, forKey key: Key, force: Bool = true) {
            guard value != nil else {
                _ = self.removeValue(forKey: key)
                return
            }
            guard force || self[key] == nil else { return }
            self[key] = value
        }
        
        /// - Returns: True if value for the key existed
        public mutating func removeValue(forKey key: Key) -> Bool {
            return self.raw.removeValue(forKey: key.rawValue) != nil
        }
    }
}
