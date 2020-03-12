import XCTest
import Restler

class RestlerStringEncodableTests: XCTestCase {}

extension RestlerStringEncodableTests {
    func testRestlerStringValue_decimal() {
        //Arrange
        let sut: Decimal = 2.33
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "2.33")
    }
    
    func testRestlerStringValue_double() {
        //Arrange
        let sut: Double = 2.33
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "2.33")
    }
    
    func testRestlerStringValue_float() {
        //Arrange
        let sut: Float = 2.33
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "2.33")
    }
    
    func testRestlerStringValue_int() {
        //Arrange
        let sut: Int = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_int8() {
        //Arrange
        let sut: Int8 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_int16() {
        //Arrange
        let sut: Int16 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_int32() {
        //Arrange
        let sut: Int32 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_int64() {
        //Arrange
        let sut: Int64 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_uint() {
        //Arrange
        let sut: UInt = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_uint8() {
        //Arrange
        let sut: UInt8 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_uint16() {
        //Arrange
        let sut: UInt16 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_uint32() {
        //Arrange
        let sut: UInt32 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_uint64() {
        //Arrange
        let sut: UInt64 = 24
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "24")
    }
    
    func testRestlerStringValue_string() {
        //Arrange
        let sut: String = "hello"
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "hello")
    }
    
    func testRestlerStringValue_url() throws {
        //Arrange
        let urlString = "https://example.com/some?name=hey"
        let sut: URL = try XCTUnwrap(URL(string: urlString))
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, urlString)
    }
    
    func testRestlerStringValue_boolTrue() {
        //Arrange
        let sut: Bool = true
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "true")
    }
    
    func testRestlerStringValue_boolFalse() {
        //Arrange
        let sut: Bool = false
        //Act
        let string = sut.restlerStringValue
        //Assert
        XCTAssertEqual(string, "false")
    }
}
