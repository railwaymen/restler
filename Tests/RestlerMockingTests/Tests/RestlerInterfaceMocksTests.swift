import XCTest
import Restler

class DecodableErrorMock: RestlerErrorDecodable {
    required init?(response _: Restler.Response) {}
}

struct SomeObject: Codable, Equatable {
    let id: Int
}

class RestlerInterfaceMocksTests: XCTestCase {
    private var restler: RestlerMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
    }
}

extension RestlerInterfaceMocksTests {
    func test() throws {
        //Arrange
        let object = SomeObject(id: 12)
        var completionResult: Result<SomeObject, Error>?
        //Act
        _ = self.restler
            .post(EndpointMock.mock)
            .body(object)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject.self)
            .onCompletion { completionResult = $0 }
            .start()
        try XCTUnwrap(self.restler.postReturnValue.getDecodeReturnedMock()?.onCompletionParams.last).handler(.success(object))
        //Assert
        let bodyObject = try XCTUnwrap(self.restler.postReturnValue.bodyParams.last?.object as? SomeObject)
        XCTAssertEqual(bodyObject, object)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), object)
    }
}
