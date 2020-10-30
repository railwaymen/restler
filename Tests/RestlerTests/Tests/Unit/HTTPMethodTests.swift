import XCTest
@testable import RestlerCore

final class HTTPMethodTests: XCTestCase {}

// MARK: - name
extension HTTPMethodTests {
    func testName_get() {
        // Arrange
        let sut: HTTPMethod = .get(query: [])
        // Assert
        XCTAssertEqual(sut.name, "GET")
    }
    
    func testName_post() {
        // Arrange
        let sut: HTTPMethod = .post(content: nil)
        // Assert
        XCTAssertEqual(sut.name, "POST")
    }
    
    func testName_put() {
        // Arrange
        let sut: HTTPMethod = .put(content: nil)
        // Assert
        XCTAssertEqual(sut.name, "PUT")
    }
    
    func testName_patch() {
        // Arrange
        let sut: HTTPMethod = .patch(content: nil)
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

// MARK: - query
extension HTTPMethodTests {
    func testQuery_get() {
        // Arrange
        let queryParameters = ["key": "value", "nil": nil, "some": "another"].map { URLQueryItem(name: $0, value: $1) }
        let sut: HTTPMethod = .get(query: queryParameters)
        // Assert
        XCTAssertEqual(sut.query, queryParameters)
    }
    
    func testQuery_post() throws {
        // Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let sut: HTTPMethod = .post(content: try JSONEncoder().encode(content))
        // Assert
        XCTAssertNil(sut.query)
    }
    
    func testQuery_put() throws {
        // Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let sut: HTTPMethod = .put(content: try JSONEncoder().encode(content))
        // Assert
        XCTAssertNil(sut.query)
    }
    
    func testQuery_patch() throws {
        // Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let sut: HTTPMethod = .patch(content: try JSONEncoder().encode(content))
        // Assert
        XCTAssertNil(sut.query)
    }
    
    func testQuery_delete() throws {
        // Arrange
        let sut: HTTPMethod = .delete
        // Assert
        XCTAssertNil(sut.query)
    }
    
    func testQuery_head() throws {
        // Arrange
        let sut: HTTPMethod = .head
        // Assert
        XCTAssertNil(sut.query)
    }
}

// MARK: - content
extension HTTPMethodTests {
    func testContent_get() {
        // Arrange
        let queryParameters = ["key": "value", "nil": nil, "some": "another"].map { URLQueryItem(name: $0, value: $1) }
        let sut: HTTPMethod = .get(query: queryParameters)
        // Assert
        XCTAssertNil(sut.content)
    }
    
    func testContent_post() throws {
        // Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let data = try JSONEncoder().encode(content)
        let sut: HTTPMethod = .post(content: data)
        // Assert
        XCTAssertEqual(sut.content, data)
    }
    
    func testContent_put() throws {
        // Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let data = try JSONEncoder().encode(content)
        let sut: HTTPMethod = .put(content: data)
        // Assert
        XCTAssertEqual(sut.content, data)
    }
    
    func testContent_patch() throws {
        // Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let data = try JSONEncoder().encode(content)
        let sut: HTTPMethod = .patch(content: data)
        // Assert
        XCTAssertEqual(sut.content, data)
    }
    
    func testContent_delete() throws {
        // Arrange
        let sut: HTTPMethod = .delete
        // Assert
        XCTAssertNil(sut.content)
    }
    
    func testContent_head() throws {
        // Arrange
        let sut: HTTPMethod = .head
        // Assert
        XCTAssertNil(sut.content)
    }
}

// MARK: - isQueryAvailable
extension HTTPMethodTests {
    func testIsQueryAvailable_get() {
        // Arrange
        let sut: HTTPMethod = .get(query: [])
        // Assert
        XCTAssertTrue(sut.isQueryAvailable)
    }
    
    func testIsQueryAvailable_post() {
        // Arrange
        let sut: HTTPMethod = .post(content: nil)
        // Assert
        XCTAssertFalse(sut.isQueryAvailable)
    }
    
    func testIsQueryAvailable_put() {
        // Arrange
        let sut: HTTPMethod = .put(content: nil)
        // Assert
        XCTAssertFalse(sut.isQueryAvailable)
    }
    
    func testIsQueryAvailable_patch() {
        // Arrange
        let sut: HTTPMethod = .patch(content: nil)
        // Assert
        XCTAssertFalse(sut.isQueryAvailable)
    }
    
    func testIsQueryAvailable_delete() {
        // Arrange
        let sut: HTTPMethod = .delete
        // Assert
        XCTAssertFalse(sut.isQueryAvailable)
    }
    
    func testIsQueryAvailable_head() {
        // Arrange
        let sut: HTTPMethod = .head
        // Assert
        XCTAssertFalse(sut.isQueryAvailable)
    }
}

// MARK: - isBodyAvailable
extension HTTPMethodTests {
    func testIsBodyAvailable_get() {
        // Arrange
        let sut: HTTPMethod = .get(query: [])
        // Assert
        XCTAssertFalse(sut.isBodyAvailable)
    }
    
    func testIsBodyAvailable_post() {
        // Arrange
        let sut: HTTPMethod = .post(content: nil)
        // Assert
        XCTAssertTrue(sut.isBodyAvailable)
    }
    
    func testIsBodyAvailable_put() {
        // Arrange
        let sut: HTTPMethod = .put(content: nil)
        // Assert
        XCTAssertTrue(sut.isBodyAvailable)
    }
    
    func testIsBodyAvailable_patch() {
        // Arrange
        let sut: HTTPMethod = .patch(content: nil)
        // Assert
        XCTAssertTrue(sut.isBodyAvailable)
    }
    
    func testIsBodyAvailable_delete() {
        // Arrange
        let sut: HTTPMethod = .delete
        // Assert
        XCTAssertFalse(sut.isBodyAvailable)
    }
    
    func testIsBodyAvailable_head() {
        // Arrange
        let sut: HTTPMethod = .head
        // Assert
        XCTAssertFalse(sut.isBodyAvailable)
    }
}
