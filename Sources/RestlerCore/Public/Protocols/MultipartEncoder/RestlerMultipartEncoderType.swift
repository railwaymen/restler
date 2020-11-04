import Foundation

public protocol RestlerMultipartEncoderType: class {
    func container<Key>(using _: Key.Type) -> Restler.MultipartEncoder.Container<Key>
    func encode<T>(_ object: T, boundary: String) throws -> Data? where T: RestlerMultipartEncodable
}
