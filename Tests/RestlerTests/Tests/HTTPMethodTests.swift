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
    
    func testName_post() {
        //Arrange
        let sut: HTTPMethod = .post(content: nil)
        //Assert
        XCTAssertEqual(sut.name, "POST")
    }
    
    func testName_put() {
        //Arrange
        let sut: HTTPMethod = .put(content: nil)
        //Assert
        XCTAssertEqual(sut.name, "PUT")
    }
    
    func testName_delete() {
        //Arrange
        let sut: HTTPMethod = .delete
        //Assert
        XCTAssertEqual(sut.name, "DELETE")
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
    
    func testQuery_post() throws {
        //Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let sut: HTTPMethod = .post(content: try JSONEncoder().encode(content))
        //Assert
        XCTAssertNil(sut.query)
    }
    
    func testQuery_put() throws {
        //Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let sut: HTTPMethod = .put(content: try JSONEncoder().encode(content))
        //Assert
        XCTAssertNil(sut.query)
    }
    
    func testQuery_delete() throws {
        //Arrange
        let sut: HTTPMethod = .delete
        //Assert
        XCTAssertNil(sut.query)
    }
}

// MARK: - content
extension HTTPMethodTests {
    func testContent_get() {
        //Arrange
        let queryParameters = ["key": "value", "nil": nil, "some": "another"]
        let sut: HTTPMethod = .get(query: queryParameters)
        //Assert
        XCTAssertNil(sut.content)
    }
    
    func testContent_post() throws {
        //Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let data = try JSONEncoder().encode(content)
        let sut: HTTPMethod = .post(content: data)
        //Assert
        XCTAssertEqual(sut.content, data)
    }
    
    func testContent_put() throws {
        //Arrange
        let content = ["key": "value", "nil": nil, "some": "another"]
        let data = try JSONEncoder().encode(content)
        let sut: HTTPMethod = .put(content: data)
        //Assert
        XCTAssertEqual(sut.content, data)
    }
    
    func testContent_delete() throws {
        //Arrange
        let sut: HTTPMethod = .delete
        //Assert
        XCTAssertNil(sut.content)
    }
}
