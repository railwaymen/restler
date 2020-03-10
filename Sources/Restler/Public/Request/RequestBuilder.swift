import Foundation

typealias QueryParametersType = [String: String?]

extension Restler {
    public class RequestBuilder: RestlerRequestBuilderType {
        private let baseURL: URL
        private let networking: NetworkingType
        private let encoder: RestlerJSONEncoderType
        private let decoder: RestlerJSONDecoderType
        private let dictEncoder: DictionaryEncoderType
        private let dispatchQueueManager: DispatchQueueManagerType
        private let errorParser: RestlerErrorParserType
        private let method: HTTPMethod
        private let endpoint: RestlerEndpointable
        
        private var query: QueryParametersType?
        private var body: Data?
        private var errors: [Error] = []
        private var customHeaderFields: Restler.Header = .init()
        
        // MARK: - Initialization
        internal init(
            baseURL: URL,
            networking: NetworkingType,
            encoder: RestlerJSONEncoderType,
            decoder: RestlerJSONDecoderType,
            dictEncoder: DictionaryEncoderType,
            dispatchQueueManager: DispatchQueueManagerType,
            errorParser: RestlerErrorParserType,
            method: HTTPMethod,
            endpoint: RestlerEndpointable
        ) {
            self.baseURL = baseURL
            self.networking = networking
            self.encoder = encoder
            self.decoder = decoder
            self.dictEncoder = dictEncoder
            self.dispatchQueueManager = dispatchQueueManager
            self.errorParser = errorParser
            self.method = method
            self.endpoint = endpoint
        }
        
        // MARK: - Public
        public func query<E>(_ object: E) -> Self where E: Encodable {
            guard case .get = self.method else { return self }
            do {
                self.query = try self.dictEncoder.encode(object)
            } catch {
                self.errors.append(Error.common(type: .invalidParameters, base: error))
            }
            return self
        }
        
        public func body<E>(_ object: E) -> Self where E: Encodable {
            do {
                self.body = try self.encoder.encode(object)
            } catch {
                self.errors.append(Error.common(type: .invalidParameters, base: error))
            }
            return self
        }
        
        public func setInHeader(_ value: String, forKey key: Restler.Header.Key) -> Self {
            self.customHeaderFields[key] = value
            return self
        }
        
        public func failureDecode<T>(_ type: T.Type) -> Self where T: RestlerErrorDecodable {
            self.errorParser.decode(type)
            return self
        }
        
        public func decode<T>(_ type: T?.Type) -> Request<T?> where T: Decodable {
            return OptionalDecodableRequest<T>(
                url: self.url(for: self.endpoint),
                networking: self.networking,
                encoder: self.encoder,
                decoder: self.decoder,
                dispatchQueueManager: self.dispatchQueueManager,
                method: self.buildMethod(),
                errors: self.errors,
                errorParser: self.errorParser,
                customHeaderFields: self.customHeaderFields)
        }
        
        public func decode<T>(_ type: T.Type) -> Request<T> where T: Decodable {
            return DecodableRequest<T>(
                url: self.url(for: self.endpoint),
                networking: self.networking,
                encoder: self.encoder,
                decoder: self.decoder,
                dispatchQueueManager: self.dispatchQueueManager,
                method: self.buildMethod(),
                errors: self.errors,
                errorParser: self.errorParser,
                customHeaderFields: self.customHeaderFields)
        }
        
        public func decode(_ type: Void.Type) -> Request<Void> {
            return VoidRequest(
                url: self.url(for: self.endpoint),
                networking: self.networking,
                encoder: self.encoder,
                decoder: self.decoder,
                dispatchQueueManager: self.dispatchQueueManager,
                method: self.buildMethod(),
                errors: self.errors,
                errorParser: self.errorParser,
                customHeaderFields: self.customHeaderFields)
        }
    }
}

// MARK: - Private
extension Restler.RequestBuilder {
    private func url(for endpoint: RestlerEndpointable) -> URL {
        return self.baseURL.appendingPathComponent(endpoint.stringValue)
    }
    
    private func buildMethod() -> HTTPMethod {
        switch self.method {
        case .get:
            return .get(query: self.query ?? [:])
        case .post:
            return .post(content: self.body)
        case .put:
            return .put(content: self.body)
        case .delete:
            return .delete
        }
    }
}
