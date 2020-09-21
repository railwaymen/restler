import Foundation
#if canImport(Combine)
import Combine
#endif

public typealias RestlerGetRequestBuilderType =
    RestlerQueryRequestBuilderType
    & RestlerDecodableResponseRequestBuilderType
    & RestlerDownloadRequestBuilderType

public typealias RestlerPostRequestBuilderType =
    RestlerBodyRequestBuilderType
    & RestlerMultipartRequestBuilderType
    & RestlerDecodableResponseRequestBuilderType

public typealias RestlerPutRequestBuilderType =
    RestlerBodyRequestBuilderType
    & RestlerDecodableResponseRequestBuilderType

public typealias RestlerPatchRequestBuilderType =
    RestlerBodyRequestBuilderType
    & RestlerDecodableResponseRequestBuilderType

public typealias RestlerDeleteRequestBuilderType =
    RestlerDecodableResponseRequestBuilderType

public typealias RestlerHeadRequestBuilderType =
    RestlerBasicRequestBuilderType

// MARK: - RestlerRequestBuilderType
/// A request builder. Builds a request from the given data.
public protocol RestlerBasicRequestBuilderType: class {
    
    /// Sets custom value for the header in the single request.
    ///
    /// Use this if you want to send a specific value in the header of a single request.
    /// This value will override existing one in the header or will be added if header doesn't conint the key yet.
    ///
    /// - Note:
    ///   This function doesn't remove existing field in the header.
    ///
    /// - Parameters:
    ///   - value: A string value for the key. If nil, a value for the key will be removed.
    ///   - key: A key for the value.
    ///
    /// - Returns: `self` for chaining.
    ///
    func setInHeader(_ value: String?, forKey key: Restler.Header.Key) -> Self
    
    /// Try to decode the error on failure of the data task.
    ///
    /// If the request will end with error, the given error would be decoded if init of the error doesn't return nil.
    /// Otherwise the Restler.Error.common will be returned.
    ///
    /// - Note:
    ///   If multiple errors will be decoded. The completion will return Restler.Error.multiple with all the decoded errors.
    ///
    /// - Parameters:
    ///   - type: A type for the error to be decoded. It will be added to an array of errors to decode on failed request.
    ///
    /// - Returns: `self` for chaining.
    ///
    func failureDecode<T>(_ type: T.Type) -> Self where T: RestlerErrorDecodable
    
    /// Use for custom modifications of the URLRequest after setting it up with the builder's values.
    ///
    /// - Parameters:
    ///   - modification: A mutating function called just before beginning a data task for the request.
    ///
    /// - Returns: `self` for chaining.
    ///
    func customRequestModification(_ modification: ((inout URLRequest) -> Void)?) -> Self
    
    /// Calls handler if any error have occured during the request building proccess.
    ///
    /// - Parameters:
    ///   - handler: A closure called only if any error have occured while building the request.
    ///
    /// - Returns: `self` for chaining.
    ///
    func catching(_ handler: ((Restler.Error) -> Void)?) -> Self
    
    /// Sets a dispatch queue on which finish handlers will be called.
    ///
    /// Detault queue **IS NOT** the main queue and it's picked by the `URLSession`.
    ///
    /// - Parameters:
    ///   - queue: A dispatch queue on which finish handlers will be called. If nil, default queue will be use.
    ///
    /// - Returns: `self` for chaining.
    ///
    func receive(on queue: DispatchQueue?) -> Self
    
    /// Builds a request with a decoding type.
    ///
    /// Ignores any data received on the successful request.
    ///
    /// - Parameters:
    ///   - type: `Void.self`
    ///
    /// - Returns: Appropriate request for the given type.
    ///
    func decode(_ type: Void.Type) -> Restler.Request<Void>
    
    /// Builds a URLRequest instance and returns it.
    ///
    /// - Returns: A URLRequest instance basing on provided data.
    /// Returns nil if building error have occured. Handle the error using the `catching(_:)` function.
    ///
    func urlRequest() -> URLRequest?
    
    #if canImport(Combine)
    /// Builds a request and returns publisher for Combine support.
    ///
    /// - Returns: DataTaskPublisher for support of Combine using.
    /// Nil if building error have occured. Handle the error using the `catching(_:)` function.
    ///
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func publisher() -> AnyPublisher<URLSession.DataTaskPublisher.Output, URLSession.DataTaskPublisher.Failure>?
    #endif
}

// MARK: - RestlerQueryRequestBuilderType
public protocol RestlerQueryRequestBuilderType: RestlerBasicRequestBuilderType {
    
    /// Query encoded parameters.
    ///
    /// If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.
    ///
    /// - Parameters:
    ///   - object: A query encodable object.
    ///
    /// - Returns: `self` for chaining.
    ///
    func query<E>(_ object: E) -> Self where E: RestlerQueryEncodable
}

// MARK: - RestlerBodyRequestBuilderType
public protocol RestlerBodyRequestBuilderType: RestlerBasicRequestBuilderType {
    
    /// Sets body of the request.
    ///
    /// If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.
    ///
    /// - Parameters:
    ///   - object: An encodable object.
    ///
    /// - Returns: `self` for chaining.
    ///
    func body<E>(_ object: E) -> Self where E: Encodable
}

// MARK: - RestlerMultipartRequestBuilderType
public protocol RestlerMultipartRequestBuilderType: RestlerBasicRequestBuilderType {
    
    /// Sets body of the request.
    ///
    /// If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.
    ///
    /// - Parameters:
    ///   - object: A multipart encodable object.
    ///   - boundary: A boundary string used to delimit sections of multipart.
    ///     If nil passed, it will be autogenerated. Default value is nil.
    ///
    /// - Returns: `self` for chaining.
    ///
    func multipart<E>(_ object: E, boundary: String?) -> Self where E: RestlerMultipartEncodable
}

extension RestlerMultipartRequestBuilderType {
    
    /// Sets body of the request.
    ///
    /// If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.
    ///
    /// - Parameters:
    ///   - object: A multipart encodable object.
    ///
    /// - Returns: `self` for chaining.
    ///
    public func multipart<E>(_ object: E) -> Self where E: RestlerMultipartEncodable {
        return self.multipart(object, boundary: nil)
    }
}

// MARK: - RestlerDecodableResponseRequestBuilderType
public protocol RestlerDecodableResponseRequestBuilderType: RestlerBasicRequestBuilderType {
    
    /// Builds a request with a decoding type.
    ///
    /// Optional decoding ignores the returned data if decoding of the given type failes.
    /// It returns success with nil in this case. So it is always successful if the data request was successful.
    ///
    /// - Parameters:
    ///   - type: Decodable object type to be decoded on the request completion.
    ///
    /// - Returns: Appropriate request for the given type.
    ///
    func decode<T>(_ type: T?.Type) -> Restler.Request<T?> where T: Decodable
    
    /// Builds a request with a decoding type.
    ///
    /// If decoding of the given type failes, completion will be called with `failure`
    /// containing the underlying error in the `Restler.Error.common`'s base.
    ///
    /// - Parameters:
    ///   - type: Decodable object type to be decoded on the request completion.
    ///
    /// - Returns: Appropriate request for the given type.
    ///
    func decode<T>(_ type: T.Type) -> Restler.Request<T> where T: Decodable
}

// MARK: - RestlerDownloadRequestBuilderType
public protocol RestlerDownloadRequestBuilderType: RestlerBasicRequestBuilderType {
    
    func resumeData(_ data: Data) -> Self
    
    func requestDownload() -> RestlerDownloadRequestType
}
