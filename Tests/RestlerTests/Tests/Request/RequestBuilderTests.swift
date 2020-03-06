import XCTest
@testable import Restler

class RequestBuilderTests: XCTestCase {
    private let baseURL = URL(string: "https://example.com")!
    private let endpoint = EndpointMock.mock
    private var networking: NetworkingMock!
    private var throwingEncoder: JSONEncoderThrowingMock!
    private var dictEncoder: DictionaryEncoderMock!
    private var dispatchQueueManager: DispatchQueueManagerMock!

    override func setUp() {
        super.setUp()
        self.networking = NetworkingMock()
        self.throwingEncoder = JSONEncoderThrowingMock()
        self.dictEncoder = DictionaryEncoderMock()
        self.dispatchQueueManager = DispatchQueueManagerMock()
    }
}

// MARK: - query
extension RequestBuilderTests {
    func testQuery_get_encodesQuery() throws {
        //Arrange
        let sut = self.buildSUT(method: .get(query: [:]))
        //Act
        _ = sut.query(SomeObject(id: 1, name: "name"))
        //Assert
        _ = sut.decode(Void.self).start()
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
    }
}

// MARK: - Private
extension RequestBuilderTests {
    private func buildSUT(
        encoder: RestlerJSONEncoderType = JSONEncoder(),
        decoder: RestlerJSONDecoderType = JSONDecoder(),
        method: HTTPMethod
    ) -> Restler.RequestBuilder {
        return Restler.RequestBuilder(
            baseURL: self.baseURL,
            networking: self.networking,
            encoder: encoder,
            decoder: decoder,
            dictEncoder: self.dictEncoder,
            dispatchQueueManager: self.dispatchQueueManager,
            method: method,
            endpoint: self.endpoint)
    }
}

class DictionaryEncoderMock: DictionaryEncoderType {
    var encodeReturnValue: [String: String?] = [:]
    var encodeThrownError: Error?
    
    func encode<E>(_ object: E) throws -> [String : String?] where E: Encodable {
        if let error = self.encodeThrownError {
            throw error
        }
        return self.encodeReturnValue
    }
}
