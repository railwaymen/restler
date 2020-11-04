import Foundation

public protocol RestlerJSONDecoderType: class {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: RestlerJSONDecoderType {}
