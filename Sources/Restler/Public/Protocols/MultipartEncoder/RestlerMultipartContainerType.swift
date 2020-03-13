import Foundation

public protocol RestlerMultipartContainerType: class {
    associatedtype Key
    func encode(_ value: RestlerStringEncodable, forKey key: Key) throws
    func encode(_ value: Restler.MultipartObject, forKey key: Key) throws
}
