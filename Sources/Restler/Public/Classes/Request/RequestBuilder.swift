import Foundation

typealias QueryParametersType = [URLQueryItem]

extension Restler {
    public final class RequestBuilder {
        private let dependencies: Dependencies
        private var form: Form
        
        // MARK: - Initialization
        internal init(
            dependencies: Dependencies,
            header: Restler.Header,
            errorParser: RestlerErrorParserType
        ) {
            self.dependencies = dependencies
            self.form = Form(
                header: header,
                errorParser: errorParser)
        }
    }
}

// MARK: - Structures
extension Restler.RequestBuilder {
    struct Dependencies {
        let url: URL
        let networking: NetworkingType
        let encoder: RestlerJSONEncoderType
        let decoder: RestlerJSONDecoderType
        let queryEncoder: RestlerQueryEncoderType
        let multipartEncoder: RestlerMultipartEncoderType
        let dispatchQueueManager: DispatchQueueManagerType
        let method: HTTPMethod
    }
    
    struct Form {
        var header: Restler.Header
        var errorParser: RestlerErrorParserType
        var query: QueryParametersType?
        var body: Data?
        var errors: [Restler.Error] = []
        var customRequestModification: ((inout URLRequest) -> Void)?
        var builderErrorsHandler: ((Restler.Error) -> Void)?
    }
}

// MARK: - RestlerBasicRequestBuilderType
extension Restler.RequestBuilder: RestlerBasicRequestBuilderType {
    public func setInHeader(_ value: String?, forKey key: Restler.Header.Key) -> Self {
        self.form.header[key] = value
        return self
    }
    
    public func failureDecode<T>(_ type: T.Type) -> Self where T: RestlerErrorDecodable {
        self.form.errorParser.decode(type)
        return self
    }
    
    public func customRequestModification(_ modification: ((inout URLRequest) -> Void)?) -> Self {
        self.form.customRequestModification = modification
        return self
    }
    
    public func decode(_ type: Void.Type) -> Restler.Request<Void> {
        Restler.VoidRequest(dependencies: .init(
            dependencies: self.dependencies,
            form: self.form,
            urlRequest: self.urlRequest()))
    }
    
    public func catching(_ handler: ((Restler.Error) -> Void)?) -> Self {
        self.form.builderErrorsHandler = handler
        return self
    }
    
    public func urlRequest() -> URLRequest? {
        if let error = self.form.errors.single() {
            self.form.builderErrorsHandler?(error)
            return nil
        }
        return self.dependencies.networking.buildRequest(
            url: self.dependencies.url,
            method: self.dependencies.method.combinedWith(query: self.form.query, body: self.form.body),
            header: self.form.header,
            customRequestModification: self.form.customRequestModification)
    }
    
    #if canImport(Combine)
    @available(OSX 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    public func publisher() -> URLSession.DataTaskPublisher? {
        guard let request = self.urlRequest() else { return nil }
        return self.dependencies.networking.getPublisher(urlRequest: request)
    }
    #endif
}

// MARK: - RestlerQueryRequestBuilderType
extension Restler.RequestBuilder: RestlerQueryRequestBuilderType {
    public func query<E>(_ object: E) -> Self where E: RestlerQueryEncodable {
        guard self.dependencies.method.isQueryAvailable else { return self }
        do {
            self.form.query = try self.dependencies.queryEncoder.encode(object)
            self.form.header[.contentType] = "application/x-www-form-urlencoded"
        } catch {
            self.form.errors.append(Restler.Error.common(type: .invalidParameters, base: error))
        }
        return self
    }
}

// MARK: - RestlerBodyRequestBuilderType
extension Restler.RequestBuilder: RestlerBodyRequestBuilderType {
    public func body<E>(_ object: E) -> Self where E: Encodable {
        guard self.dependencies.method.isBodyAvailable else { return self }
        do {
            self.form.body = try self.dependencies.encoder.encode(object)
            self.form.header[.contentType] = "application/json"
        } catch {
            self.form.errors.append(Restler.Error.common(type: .invalidParameters, base: error))
        }
        return self
    }
}

// MARK: - RestlerMultipartRequestBuilderType
extension Restler.RequestBuilder: RestlerMultipartRequestBuilderType {
    public func multipart<E>(_ object: E, boundary: String? = nil) -> Self where E: RestlerMultipartEncodable {
        guard self.dependencies.method.isMultipartAvailable else { return self }
        do {
            let unwrappedBoundary = boundary ?? "Boundary--\(UUID().uuidString)"
            self.form.body = try self.dependencies.multipartEncoder.encode(object, boundary: unwrappedBoundary)
            self.form.header[.contentType] = "multipart/form-data; charset=utf-8; boundary=\(unwrappedBoundary)"
        } catch {
            self.form.errors.append(Restler.Error.common(type: .invalidParameters, base: error))
        }
        return self
    }
}

// MARK: - RestlerDecodableResponseRequestBuilderType
extension Restler.RequestBuilder: RestlerDecodableResponseRequestBuilderType {
    public func decode<T>(_ type: T?.Type) -> Restler.Request<T?> where T: Decodable {
        Restler.OptionalDecodableRequest<T>(dependencies: .init(
            dependencies: self.dependencies,
            form: self.form,
            urlRequest: self.urlRequest()))
    }
    
    public func decode<T>(_ type: T.Type) -> Restler.Request<T> where T: Decodable {
        Restler.DecodableRequest<T>(dependencies: .init(
            dependencies: self.dependencies,
            form: self.form,
            urlRequest: self.urlRequest()))
    }
}
