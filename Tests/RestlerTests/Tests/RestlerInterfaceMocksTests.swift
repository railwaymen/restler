import XCTest
import Restler

final class RestlerInterfaceMocksTests: XCTestCase {
    private var restler: RestlerMock!
    
    override func setUp() {
        super.setUp()
        self.restler = RestlerMock()
    }
}

extension RestlerInterfaceMocksTests {
    func test() throws {
        // Arrange
        let object = SomeObject(id: 12, name: "some", double: 1.23)
        var completionResult: Result<SomeObject, Error>?
        // Act
        _ = self.restler
            .post(EndpointMock.mock)
            .body(object)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject.self)
            .onCompletion { completionResult = $0 }
            .start()
        XCTAssertNoThrow(try self.restler.postReturnValue.callCompletion(type: SomeObject.self, result: .success(object)))
        // Assert
        let bodyObject = try XCTUnwrap(self.restler.postReturnValue.bodyParams.last?.object as? SomeObject)
        XCTAssertEqual(bodyObject, object)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), object)
    }
}
