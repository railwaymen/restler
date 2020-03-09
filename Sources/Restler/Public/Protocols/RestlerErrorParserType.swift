import Foundation

public protocol RestlerErrorParserType {
    func decode<T>(_ type: T.Type) where T: RestlerErrorDecodable
    func stopDecoding<T>(_ type: T.Type) where T: RestlerErrorDecodable
    func copy() -> RestlerErrorParserType
    func parse(_ error: Swift.Error) -> Swift.Error
}
