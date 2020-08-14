import XCTest
@testable import Restler

final class ErrorTests: XCTestCase {}

// MARK: - Equatable
extension ErrorTests {
    
    // MARK: common
    func testEquatable_common_differentEquatableErrors() {
        //Arrange
        let sut1 = Restler.Error.common(type: .unknownError, base: TestError())
        let sut2 = Restler.Error.common(type: .unknownError, base: TestError())
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_common_differentTypes() {
        //Arrange
        let base = TestError()
        let sut1 = Restler.Error.common(type: .unknownError, base: base)
        let sut2 = Restler.Error.common(type: .internalFrameworkError, base: base)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    // MARK: request
    func testEquatable_request_same() {
        //Arrange
        let response = Restler.Response(data: Data(), response: nil, error: TestError())
        let sut1 = Restler.Error.request(type: .unknownError, response: response)
        let sut2 = Restler.Error.request(type: .unknownError, response: response)
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_request_differentResponse() {
        //Arrange
        let sut1 = Restler.Error.request(
            type: .unknownError,
            response: Restler.Response(data: Data(), response: nil, error: TestError()))
        let sut2 = Restler.Error.request(
            type: .unknownError,
            response: Restler.Response(data: nil, response: nil, error: TestError()))
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    func testEquatable_request_differentType() {
        //Arrange
        let response = Restler.Response(data: Data(), response: nil, error: TestError())
        let sut1 = Restler.Error.request(type: .internalFrameworkError, response: response)
        let sut2 = Restler.Error.request(type: .unknownError, response: response)
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    // MARK: multiple
    func testEquatable_multiple_same() {
        //Arrange
        let response = Restler.Response(data: Data(), response: nil, error: TestError())
        let error1 = Restler.Error.request(type: .unknownError, response: response)
        let error2 = Restler.Error.common(type: .unknownError, base: TestError())
        let sut1 = Restler.Error.multiple([error1, error2])
        let sut2 = Restler.Error.multiple([error1, error2])
        //Assert
        XCTAssertEqual(sut1, sut2)
    }
    
    func testEquatable_multiple_different() {
        //Arrange
        let response = Restler.Response(data: Data(), response: nil, error: TestError())
        let error1 = Restler.Error.request(type: .unknownError, response: response)
        let error2 = Restler.Error.common(type: .unknownError, base: TestError())
        let sut1 = Restler.Error.multiple([error1, error2])
        let sut2 = Restler.Error.multiple([error1])
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
    
    // MARK: Different cases
    func testEquatable_different_requestAndCommon() {
        //Arrange
        let sut1 = Restler.Error.request(type: .unknownError, response: .init(data: nil, response: nil, error: nil))
        let sut2 = Restler.Error.common(type: .unknownError, base: TestError())
        //Assert
        XCTAssertNotEqual(sut1, sut2)
    }
}
