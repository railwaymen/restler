import Foundation

/// Class for making requests to the API
open class Restler: RestlerType {
    private let baseURL: URL
    private let networking: NetworkingType
    private let dispatchQueueManager: DispatchQueueManagerType
    
    open var encoder: RestlerJSONEncoderType
    
    open var decoder: RestlerJSONDecoderType
    
    open var errorParser: RestlerErrorParserType
    
    open var header: Restler.Header {
        get {
            return self.networking.header
        }
        set {
            self.networking.header = newValue
        }
    }
    
    // MARK: - Initialization
    
    /// Default initializer.
    ///
    /// - Parameters:
    ///   - encoder: Encoder used for encoding requests' body.
    ///   - decoder: Decoder used for decoding response's data to expected object.
    ///
    public convenience init(
        baseURL: URL,
        encoder: RestlerJSONEncoderType = JSONEncoder(),
        decoder: RestlerJSONDecoderType = JSONDecoder()
    ) {
        self.init(
            baseURL: baseURL,
            networking: Networking(),
            dispatchQueueManager: DispatchQueueManager(),
            encoder: encoder,
            decoder: decoder,
            errorParser: Restler.ErrorParser())
    }
    
    init(
        baseURL: URL,
        networking: NetworkingType,
        dispatchQueueManager: DispatchQueueManagerType,
        encoder: RestlerJSONEncoderType,
        decoder: RestlerJSONDecoderType,
        errorParser: RestlerErrorParserType
    ) {
        self.baseURL = baseURL
        self.networking = networking
        self.dispatchQueueManager = dispatchQueueManager
        self.encoder = encoder
        self.decoder = decoder
        self.errorParser = errorParser
    }
    
    // MARK: - Open
    
    open func get(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        return self.requestBuilder(for: .get(query: [:]), to: endpoint)
    }
    
    open func post(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        return self.requestBuilder(for: .post(content: nil), to: endpoint)
    }
    
    open func put(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        return self.requestBuilder(for: .put(content: nil), to: endpoint)
    }
    
    open func delete(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType {
        return self.requestBuilder(for: .delete, to: endpoint)
    }
}

// MARK: - Private
extension Restler {
    private func requestBuilder(for method: HTTPMethod, to endpoint: RestlerEndpointable) -> RequestBuilder {
        return RequestBuilder(
            baseURL: self.baseURL,
            networking: self.networking,
            encoder: self.encoder,
            decoder: self.decoder,
            dictEncoder: DictionaryEncoder(encoder: self.encoder, serialization: CustomJSONSerialization()),
            dispatchQueueManager: self.dispatchQueueManager,
            errorParser: self.errorParser.copy(),
            method: method,
            endpoint: endpoint)
    }
}
