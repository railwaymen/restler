import Foundation

public protocol RestlerJSONEncoderType: class {
    func encode<T>(_ value: T) throws -> Data where T: Encodable
}

extension JSONEncoder: RestlerJSONEncoderType {}
