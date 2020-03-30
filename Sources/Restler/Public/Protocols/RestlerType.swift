import Foundation

/// Interface of the main functional class of the Restler framework.
public protocol RestlerType: class {
    
    /// Encoder used for encoding requests' body.
    var encoder: RestlerJSONEncoderType { get set }
    
    /// Decoder used for decoding response's data to expected object.
    var decoder: RestlerJSONDecoderType { get set }
    
    /// Error parser for failed requests. Setting its decoded errors makes trying to decode them globally.
    var errorParser: RestlerErrorParserType { get set }
    
    /// Global header sent in requests.
    var header: Restler.Header { get set }
    
    
    /// Creates GET request builder.
    ///
    /// - Parameter endpoint: Endpoint for the request
    ///
    /// - Returns: Restler.RequestBuilder for building the request in the functional way.
    ///
    func get(_ endpoint: RestlerEndpointable) -> RestlerGetRequestBuilderType
    
    /// Creates POST request builder.
    ///
    /// - Parameter endpoint: Endpoint for the request
    ///
    /// - Returns: Restler.RequestBuilder for building the request in the functional way.
    ///
    func post(_ endpoint: RestlerEndpointable) -> RestlerPostRequestBuilderType
    
    /// Creates PUT request builder.
    ///
    /// - Parameter endpoint: Endpoint for the request
    ///
    /// - Returns: Restler.RequestBuilder for building the request in the functional way.
    ///
    func put(_ endpoint: RestlerEndpointable) -> RestlerPutRequestBuilderType
    
    /// Creates PATCH request builder.
    ///
    /// - Parameter endpoint: Endpoint for the request
    ///
    /// - Returns: Restler.RequestBuilder for building the request in the functional way.
    ///
    func patch(_ endpoint: RestlerEndpointable) -> RestlerPatchRequestBuilderType
    
    /// Creates DELETE request builder.
    ///
    /// - Parameter endpoint: Endpoint for the request
    ///
    /// - Returns: Restler.RequestBuilder for building the request in the functional way.
    ///
    func delete(_ endpoint: RestlerEndpointable) -> RestlerDeleteRequestBuilderType
    
    /// Creates HEAD request builder.
    ///
    /// - Parameter endpoint: Endpoint for the request
    ///
    /// - Returns: Restler.RequestBuilder for building the request in the functional way.
    ///
    func head(_ endpoint: RestlerEndpointable) -> RestlerHeadRequestBuilderType
}
