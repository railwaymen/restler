import XCTest
@testable import Restler

class HeaderTests: XCTestCase {}

// MARK: - init(_:)
extension HeaderTests {
    func testInit_defaultValue() {
        //Act
        let sut = Restler.Header()
        //Assert
        XCTAssertTrue(sut.raw.isEmpty)
    }
    
    func testInit_setsRaw() {
        //Arrange
        let header: [Restler.Header.Key: String] = [
            .custom("Accept"): "accept content",
            .custom("Content-Type"): "content type"
        ]
        //Act
        let sut = Restler.Header(header)
        //Assert
        XCTAssertEqual(sut.raw.count, header.count)
        XCTAssertEqual(sut.raw["Accept"], header[.custom("Accept")])
        XCTAssertEqual(sut.raw["Content-Type"], header[.custom("Content-Type")])
    }
}

// MARK: - dict get
extension HeaderTests {
    func testDict() {
        //Arrange
        let headers: [Restler.Header.Key: String] = [
            .accept: "accept content",
            .contentType: "content",
            .custom("Language"): "en"
        ]
        let sut = Restler.Header(headers)
        //Act
        let getDict = sut.dict
        //Assert
        XCTAssertEqual(getDict, headers)
    }
}

// MARK: - subscript(_:) get
extension HeaderTests {
    func testSubscriptGet_existingKeyValue() {
        //Arrange
        let sut = Restler.Header([.accept: "accept"])
        //Act
        let accept = sut[.accept]
        //Assert
        XCTAssertEqual(accept, "accept")
    }
    
    func testSubscriptGet_notExistingKeyValue() {
        //Arrange
        let sut = Restler.Header()
        //Act
        let accept = sut[.accept]
        //Assert
        XCTAssertNil(accept)
    }
}

// MARK: - subscript(_:) set
extension HeaderTests {
    func testSubscriptSet_existingKeyValue() {
        //Arrange
        var sut = Restler.Header([.accept: "accept"])
        let newValue = "new Value"
        //Act
        sut[.accept] = newValue
        //Assert
        XCTAssertEqual(sut[.accept], newValue)
    }
    
    func testSubscriptSet_notExistingKeyValue() {
        //Arrange
        var sut = Restler.Header()
        let newValue = "new Value"
        //Act
        sut[.accept] = newValue
        //Assert
        XCTAssertEqual(sut[.accept], newValue)
    }
}

// MARK: - removeValue(forKey:)
extension HeaderTests {
    func testRemoveValues_existingValue() {
        //Arrange
        var sut = Restler.Header([.accept: "accept"])
        //Act
        let existed = sut.removeValue(forKey: .accept)
        //Assert
        XCTAssertTrue(existed)
        XCTAssertNil(sut[.accept])
    }
    
    func testRemoveValues_notExistingValue() {
        //Arrange
        var sut = Restler.Header()
        //Act
        let existed = sut.removeValue(forKey: .accept)
        //Assert
        XCTAssertFalse(existed)
        XCTAssertNil(sut[.accept])
    }
}

// MARK: - setBasicAuthorization(username:password:)
extension HeaderTests {
    func testSetBasicAuthorization() throws {
        //Arrange
        var sut = Restler.Header()
        let username = "Some user hello"
        let password = "myPassword1!"
        let credentials = "\(username):\(password)"
        let expectedValue = "Basic \(try XCTUnwrap(credentials.data(using: .utf8)).base64EncodedString())"
        //Act
        sut.setBasicAuthorization(username: username, password: password)
        //Assert
        XCTAssertEqual(sut[.authorization], expectedValue)
    }
}
