import Foundation

public protocol JSONDecoderType: class {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: JSONDecoderType {}
