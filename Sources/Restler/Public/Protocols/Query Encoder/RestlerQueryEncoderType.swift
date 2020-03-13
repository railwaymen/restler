import Foundation

public protocol RestlerQueryEncoderType {
    func container<Key: CodingKey>(using: Key.Type) -> Restler.QueryEncoder.KeyedContainer<Key>
    func stringKeyedContainer() -> Restler.QueryEncoder.StringKeyedContainer
    func encode<Key: RestlerQueryEncodable>(_ object: Key) throws -> [URLQueryItem]
}
