import Foundation

public protocol RestlerQueryEncoderContainerType: class {
    associatedtype Key
    func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws
//    func encode(_ value: [RestlerStringEncodable]?, forKey key: Key) throws
}
