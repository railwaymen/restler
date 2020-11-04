import XCTest
@testable import RestlerCore

final class ErrorsTypeTests: XCTestCase {
    private var response: HTTPURLResponseMock!
    
    override func setUp() {
        super.setUp()
        self.response = HTTPURLResponseMock()
    }
}

// MARK: - init(result:)
extension ErrorsTypeTests {
    func testInit_code15() {
        // Arrange
        let statusCode = 15
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.noInternetConnection)
    }
    
    func testInit_code23() {
        // Arrange
        let statusCode = 23
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.timeout)
    }
    
    func testInit_code401() {
        // Arrange
        let statusCode = 401
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.unauthorized)
    }
    
    func testInit_code403() {
        // Arrange
        let statusCode = 403
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.forbidden)
    }
    
    func testInit_code404() {
        // Arrange
        let statusCode = 404
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.notFound)
    }
    
    func testInit_code422() {
        // Arrange
        let statusCode = 422
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.validationError)
    }
    
    func testInit_code500() {
        // Arrange
        let statusCode = 500
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.serverError)
    }
    
    func testInit_codeNSURLErrorBadServerResponse() {
        // Arrange
        let statusCode = NSURLErrorBadServerResponse
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.invalidResponse)
    }
    
    func testInit_codeNSURLErrorBadURL() {
        // Arrange
        let statusCode = NSURLErrorBadURL
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.invalidURL)
    }
    
    func testInit_codeNSURLErrorNetworkConnectionLost() {
        // Arrange
        let statusCode = NSURLErrorNetworkConnectionLost
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.noInternetConnection)
    }
    
    func testInit_codeNSURLErrorTimedOut() {
        // Arrange
        let statusCode = NSURLErrorTimedOut
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.timeout)
    }
    
    func testInit_codeNSURLErrorUnknown() {
        // Arrange
        let statusCode = NSURLErrorUnknown
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.unknownError)
    }
    
    func testInit_codeNSURLErrorCancelled() {
        // Arrange
        let statusCode = NSURLErrorCancelled
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertEqual(sut, Restler.ErrorType.requestCancelled)
    }
    
    func testInit_codeUnknownValue() {
        // Arrange
        let statusCode = 111111111
        // Act
        let sut = Restler.ErrorType(statusCode: statusCode)
        // Assert
        XCTAssertNil(sut)
    }
}
