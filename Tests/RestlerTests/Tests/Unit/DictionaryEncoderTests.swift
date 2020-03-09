import XCTest
@testable import Restler

class DictionaryEncoderTests: XCTestCase {
    private let encoder = JSONEncoder()
    private var serialization: CustomJSONSerializationMock!
    
    override func setUp() {
        super.setUp()
        self.serialization = CustomJSONSerializationMock()
    }
}

// MARK: - encode(_:)
extension DictionaryEncoderTests {
    func testEncode_encodingFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedError = TestError()
        let object = ThrowingObject()
        object.thrownError = expectedError
        //Act
        //Assert
        XCTAssertThrowsError(try sut.encode(object)) { error in
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }
    
    func testEncode_decodingFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "some", double: 1.23)
        let expectedError = TestError()
        self.serialization.jsonObjectThrownError = expectedError
        //Act
        //Assert
        XCTAssertThrowsError(try sut.encode(object)) { error in
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }
    
    func testEncode_decodedObjectNotADictionary() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "some", double: 1.23)
        self.serialization.jsonObjectReturnValue = object
        //Act
        //Assert
        XCTAssertThrowsError(try sut.encode(object)) { error in
            guard case let .common(type, base) = error as? Restler.Error else { return XCTFail() }
            XCTAssertEqual(type, .internalFrameworkError)
            XCTAssert(base is EncodingError)
        }
    }
    
    func testEncode_parsesData() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let object = SomeObject(id: 1, name: "some", double: 1.23)
        self.serialization.jsonObjectReturnValue = ["id": 1, "name": "some", "double": 1.23, "unexpected": url] as [String: Any]
        //Act
        let dictionary = try sut.encode(object)
        //Assert
        XCTAssertEqual(dictionary, ["id": "1", "name": "some", "double": "1.23"])
    }
}

// MARK: - Private
extension DictionaryEncoderTests {
    private func buildSUT() -> DictionaryEncoder {
        return DictionaryEncoder(
            encoder: self.encoder,
            serialization: self.serialization)
    }
}
