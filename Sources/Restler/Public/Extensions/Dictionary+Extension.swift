import Foundation

extension Dictionary: RestlerQueryEncodable where Key == String, Value: RestlerStringEncodable {
    public func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.stringKeyedContainer()
        try self.forEach { key, value in
            try container.encode(value, forKey: key)
        }
    }
}
