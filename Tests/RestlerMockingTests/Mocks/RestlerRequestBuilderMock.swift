import XCTest
import Restler

class RestlerRequestBuilderMock {
    
    // MARK: - RestlerRequestBuilderType
    private(set) var queryParams: [QueryParams] = []
    struct QueryParams {
        let object: Any
    }
    
    private(set) var bodyParams: [BodyParams] = []
    struct BodyParams {
        let object: Any
    }
    
    private(set) var setInHeaderParams: [SetInHeaderParams] = []
    struct SetInHeaderParams {
        let value: String
        let key: Restler.Header.Key
    }
    
    private(set) var failureDecodeParams: [FailureDecodeParams] = []
    struct FailureDecodeParams {
        let type: RestlerErrorDecodable.Type
    }
    
    private(set) var decodeReturnedMocks: [Any] = []
    private(set) var decodeParams: [DecodeParams] = []
    struct DecodeParams {
        let type: Any
    }
    
    func getDecodeReturnedMock<T>(at index: Int = 0) -> RestlerRequestMock<T>? {
        return decodeReturnedMocks[index] as? RestlerRequestMock<T>
    }}

// MARK: - RestlerRequestBuilderType
extension RestlerRequestBuilderMock: RestlerRequestBuilderType {
    func query<E>(_ object: E) -> Self where E: Encodable {
        self.queryParams.append(QueryParams(object: object))
        return self
    }
    
    func body<E>(_ object: E) -> Self where E: Encodable {
        self.bodyParams.append(BodyParams(object: object))
        return self
    }
    
    func setInHeader(_ value: String, forKey key: Restler.Header.Key) -> Self {
        self.setInHeaderParams.append(SetInHeaderParams(value: value, key: key))
        return self
    }
    
    func failureDecode<T>(_ type: T.Type) -> Self where T: RestlerErrorDecodable {
        self.failureDecodeParams.append(FailureDecodeParams(type: type))
        return self
    }
    
    func decode<T>(_ type: T?.Type) -> Restler.Request<T?> where T: Decodable {
        self.decodeParams.append(DecodeParams(type: type))
        let mock = RestlerRequestMock<T?>()
        self.decodeReturnedMocks.append(mock)
        return mock
    }
    
    func decode<T>(_ type: T.Type) -> Restler.Request<T> where T: Decodable {
        self.decodeParams.append(DecodeParams(type: type))
        let mock = RestlerRequestMock<T>()
        self.decodeReturnedMocks.append(mock)
        return mock
    }
    
    func decode(_ type: Void.Type) -> Restler.Request<Void> {
        self.decodeParams.append(DecodeParams(type: type))
        let mock = RestlerRequestMock<Void>()
        self.decodeReturnedMocks.append(mock)
        return mock
    }
}
