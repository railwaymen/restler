import Foundation

extension Restler {
    /// Header wrapper structure for Restler framework.
    public struct Header: Equatable {
        var raw: [String: String]
        
        // MARK: - Getters
        
        /// Dictionary representation of the header.
        public var dict: [Key: String] {
            return self.raw.reduce(into: [Key: String]()) { $0[Key(rawValue: $1.key)] = $1.value }
        }
        
        // MARK: - Initialization
        
        /// Default init for the Header.
        ///
        /// - Parameters:
        ///   - header: Dictionary to put into the newly initialized Header.
        ///
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
        
        /// Function for removing value in the dictionary.
        ///
        /// If you don't need the returned value, you can use subscript instead.
        ///
        /// - Parameters:
        ///   - key: Key to remove value for.
        ///
        /// - Returns: True if value for the key existed
        ///
        public mutating func removeValue(forKey key: Key) -> Bool {
            return self.raw.removeValue(forKey: key.rawValue) != nil
        }
        
        /// Encodes username and password into basic authorization header field.
        ///
        /// - Parameters:
        ///   - username: The username for the basic authentication.
        ///   - password: The password for the basic authentication.
        ///
        public mutating func setAuthorization(username: String, password: String) {
            let credentialsString = "\(username):\(password)"
            guard let credentialsData = credentialsString.data(using: .utf8) else { return }
            let base64Credentials = credentialsData.base64EncodedString()
            self[.authorization] = "Basic \(base64Credentials)"
        }
    }
}
