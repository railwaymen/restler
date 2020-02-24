import XCTest
@testable import Restler

class HTTPMethodTests: XCTestCase {}

// MARK: - name
extension HTTPMethodTests {
    func testName_get() {
        //Arrange
        let sut: HTTPMethod = .get(query: [:])
        //Assert
        XCTAssertEqual(sut.name, "GET")
    }
}

// MARK: - query
extension HTTPMethodTests {
    func testQuery_get() {
        //Arrange
        let queryParameters = ["key": "value", "nil": nil, "some": "another"]
        let sut: HTTPMethod = .get(query: queryParameters)
        //Assert
        XCTAssertEqual(sut.query, queryParameters)
    }
}
