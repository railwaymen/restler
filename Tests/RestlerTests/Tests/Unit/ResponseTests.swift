import XCTest
@testable import RestlerCore

final class ResponseTests: XCTestCase {}

// MARK: - Public init
extension ResponseTests {
    func testPublicInit() {
        // Arrange
        let data = Data()
        let response = HTTPURLResponse()
        let error = TestError()
        // Act
        let sut = Restler.Response(data: data, response: response, error: error)
        // Assert
        XCTAssertEqual(sut.data, data)
        XCTAssertEqual(sut.response, response)
        XCTAssertEqual(sut.error as? TestError, error)
    }
}

// MARK: - Internal init
extension ResponseTests {
    func testInternalInit() {
        // Arrange
        let data = Data()
        let response = HTTPURLResponse()
        let error = TestError()
        // Act
        let sut = Restler.Response(.init(data: data, response: response, error: error))
        // Assert
        XCTAssertEqual(sut.data, data)
        XCTAssertEqual(sut.response, response)
        XCTAssertEqual(sut.error as? TestError, error)
    }
}
