import XCTest
@testable import Restler

class ErrorsTests: XCTestCase {
    private var response: HTTPURLResponseMock!
    
    override func setUp() {
        super.setUp()
        self.response = HTTPURLResponseMock()
    }
}

// MARK: - init(result:)
extension ErrorsTests {
    func testInit_code15() {
        //Arrange
        self.response.statusCodeReturnValue = 15
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.noInternetConnection)
    }
    
    func testInit_code23() {
        //Arrange
        self.response.statusCodeReturnValue = 23
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.timeout)
    }
    
    func testInit_code401() {
        //Arrange
        self.response.statusCodeReturnValue = 401
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.unauthorized)
    }
    
    func testInit_code403() {
        //Arrange
        self.response.statusCodeReturnValue = 403
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.forbidden)
    }
    
    func testInit_code404() {
        //Arrange
        self.response.statusCodeReturnValue = 404
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.notFound)
    }
    
    func testInit_code422() {
        //Arrange
        self.response.statusCodeReturnValue = 422
        let error = TestError()
        let result = HTTPRequestResponse(data: nil, response: self.response, error: error)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.validationError(nil))
        guard case let .validationError(returnedError) = sut else { return XCTFail() }
        XCTAssertEqual(returnedError as? TestError, error)
    }
    
    func testInit_code500() {
        //Arrange
        self.response.statusCodeReturnValue = 500
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.serverError)
    }
    
    func testInit_codeNSURLErrorBadServerResponse() {
        //Arrange
        self.response.statusCodeReturnValue = NSURLErrorBadServerResponse
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.invalidResponse)
    }
    
    func testInit_codeNSURLErrorBadURL() {
        //Arrange
        self.response.statusCodeReturnValue = NSURLErrorBadURL
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.invalidURL)
    }
    
    func testInit_codeNSURLErrorNetworkConnectionLost() {
        //Arrange
        self.response.statusCodeReturnValue = NSURLErrorNetworkConnectionLost
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.noInternetConnection)
    }
    
    func testInit_codeNSURLErrorTimedOut() {
        //Arrange
        self.response.statusCodeReturnValue = NSURLErrorTimedOut
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.timeout)
    }
    
    func testInit_codeNSURLErrorUnknown() {
        //Arrange
        self.response.statusCodeReturnValue = NSURLErrorUnknown
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertEqual(sut, Restler.Error.unknownError)
    }
    
    func testInit_codeUnknownValue() {
        //Arrange
        self.response.statusCodeReturnValue = 111111111
        let result = HTTPRequestResponse(data: nil, response: self.response, error: nil)
        //Act
        let sut = Restler.Error(result: result)
        //Assert
        XCTAssertNil(sut)
    }
}
