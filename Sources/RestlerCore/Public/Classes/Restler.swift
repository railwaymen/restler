import Foundation

/// Class for making requests to the API
open class Restler: RestlerType {
    
    // MARK: - Internal Static
    internal static func internalError(file: StaticString = #file, line: UInt = #line) -> Restler.Error {
        return Restler.Error.common(
            type: .internalFrameworkError,
            base: NSError(
                domain: "Restler",
                code: 0,
                userInfo: [
                    "file": #file,
                    "line": #line
            ]))
    }
    
    // MARK: - Properties
    
    open var encoder: RestlerJSONEncoderType
    
    open var decoder: RestlerJSONDecoderType
    
    open var errorParser: RestlerErrorParserType
    
    open var header: Restler.Header = .init()
    
    public var levelOfLogDetails: LevelOfLogDetails {
        get { self.eventLogger.levelOfDetails }
        set { self.eventLogger.levelOfDetails = newValue }
    }
    
    private let baseURL: URL
    private let networking: NetworkingType
    private let dispatchQueueManager: DispatchQueueManagerType
    private let eventLogger: EventLoggerable
    
    private var queryEncoder: QueryEncoder { .init(jsonEncoder: self.encoder) }
    private var multipartEncoder: MultipartEncoder { .init() }
    
    // MARK: - Initialization
    
    /// Default initializer.
    ///
    /// - Parameters:
    ///   - baseURL: Base for endpoints calls.
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
            errorParser: Restler.ErrorParser(),
            eventLogger: EventLogger())
    }
    
    internal init(
        baseURL: URL,
        networking: NetworkingType,
        dispatchQueueManager: DispatchQueueManagerType,
        encoder: RestlerJSONEncoderType,
        decoder: RestlerJSONDecoderType,
        errorParser: RestlerErrorParserType,
        eventLogger: EventLoggerable
    ) {
        self.baseURL = baseURL
        self.networking = networking
        self.dispatchQueueManager = dispatchQueueManager
        self.encoder = encoder
        self.decoder = decoder
        self.errorParser = errorParser
        self.eventLogger = eventLogger
    }
    
    // MARK: - Open
    
    open func get(_ endpoint: RestlerEndpointable) -> RestlerGetRequestBuilderType {
        self.requestBuilder(for: .get, to: endpoint)
    }
    
    open func post(_ endpoint: RestlerEndpointable) -> RestlerPostRequestBuilderType {
        self.requestBuilder(for: .post, to: endpoint)
    }
    
    open func put(_ endpoint: RestlerEndpointable) -> RestlerPutRequestBuilderType {
        self.requestBuilder(for: .put, to: endpoint)
    }
    
    open func patch(_ endpoint: RestlerEndpointable) -> RestlerPatchRequestBuilderType {
        self.requestBuilder(for: .patch, to: endpoint)
    }
    
    open func delete(_ endpoint: RestlerEndpointable) -> RestlerDeleteRequestBuilderType {
        self.requestBuilder(for: .delete, to: endpoint)
    }
    
    open func head(_ endpoint: RestlerEndpointable) -> RestlerHeadRequestBuilderType {
        self.requestBuilder(for: .head, to: endpoint)
    }
}

// MARK: - Private
extension Restler {
    private func requestBuilder(for method: HTTPMethod, to endpoint: RestlerEndpointable) -> RequestBuilder {
        return RequestBuilder(
            dependencies: .init(
                url: self.url(for: endpoint),
                networking: self.networking,
                encoder: self.encoder,
                decoder: self.decoder,
                queryEncoder: self.queryEncoder,
                multipartEncoder: self.multipartEncoder,
                dispatchQueueManager: self.dispatchQueueManager,
                eventLogger: self.eventLogger,
                method: method),
            header: self.header,
            errorParser: self.errorParser)
    }
    
    private func url(for endpoint: RestlerEndpointable) -> URL {
        self.baseURL.appendingPathComponent(endpoint.restlerEndpointValue)
    }
}
