import Foundation

public protocol RestlerRequestBuilderType: class {
    func query<E>(_ object: E) -> Self where E: Encodable
    func body<E>(_ object: E) -> Self where E: Encodable
    func setInHeader(_ value: String, forKey key: Restler.Header.Key) -> Self 
    func failureDecode<T>(_ type: T.Type) -> Self where T: RestlerErrorDecodable
    func decode<T>(_ type: T?.Type) -> Restler.Request<T?> where T: Decodable
    func decode<T>(_ type: T.Type) -> Restler.Request<T> where T: Decodable
    func decode(_ type: Void.Type) -> Restler.Request<Void>
}
