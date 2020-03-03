import Foundation

public protocol JSONEncoderType: class {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: JSONEncoderType {}
