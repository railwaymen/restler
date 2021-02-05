import XCTest
@testable import RestlerCore

final class HTTPMethodTests: XCTestCase {}

// MARK: - name
extension HTTPMethodTests {
    func testName_get() {
        // Arrange
        let sut: HTTPMethod = .get
        // Assert
        XCTAssertEqual(sut.name, "GET")
    }
    
    func testName_post() {
        // Arrange
        let sut: HTTPMethod = .post
        // Assert
        XCTAssertEqual(sut.name, "POST")
    }
    
    func testName_put() {
        // Arrange
        let sut: HTTPMethod = .put
        // Assert
        XCTAssertEqual(sut.name, "PUT")
    }
    
    func testName_patch() {
        // Arrange
        let sut: HTTPMethod = .patch
        // Assert
        XCTAssertEqual(sut.name, "PATCH")
    }
    
    func testName_delete() {
        // Arrange
        let sut: HTTPMethod = .delete
        // Assert
        XCTAssertEqual(sut.name, "DELETE")
    }
    
    func testName_head() {
        // Arrange
        let sut: HTTPMethod = .head
        // Assert
        XCTAssertEqual(sut.name, "HEAD")
    }
}
