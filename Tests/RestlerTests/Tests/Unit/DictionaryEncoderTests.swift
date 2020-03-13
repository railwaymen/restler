import XCTest
@testable import Restler

class DictionaryEncoderTests: XCTestCase {}

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
        XCTAssertThrowsError(try sut.encodeToQuery(object)) { error in
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }
}

// MARK: - Private
extension DictionaryEncoderTests {
    private func buildSUT() -> DictionaryEncoder {
        return DictionaryEncoder(encoder: Restler.QueryEncoder())
    }
}
