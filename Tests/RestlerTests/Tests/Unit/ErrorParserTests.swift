import XCTest
@testable import Restler

class ErrorParserTests: XCTestCase {}

// MARK: - parse(_:)
extension ErrorParserTests {
    func testParse_unknownError() throws {
        //Arrange
        let sut = Restler.ErrorParser(decodingErrors: [DecodableErrorMock.self])
        let expectedError = TestError()
        //Act
        let error = sut.parse(expectedError)
        //Assert
        XCTAssertEqual(error as? TestError, expectedError)
    }
    
    func testParse_notDecodableError() throws {
        //Arrange
        let sut = Restler.ErrorParser(decodingErrors: [UndecodableErrorMock.self])
        let response = Restler.Response(data: nil, response: nil, error: TestError())
        let expectedError = Restler.Error.request(type: .unknownError, response: response)
        //Act
        let error = sut.parse(expectedError)
        //Assert
        XCTAssertEqual(error as? Restler.Error, expectedError)
    }
    
    func testParse_decodableError_inInit() throws {
        //Arrange
        let sut = Restler.ErrorParser(decodingErrors: [DecodableErrorMock.self])
        let response = Restler.Response(data: nil, response: nil, error: TestError())
        //Act
        let error = sut.parse(Restler.Error.request(type: .unknownError, response: response))
        //Assert
        XCTAssert(error is DecodableErrorMock)
    }
    
    func testParse_decodableError_addedByDecode() throws {
        //Arrange
        var sut = Restler.ErrorParser()
        sut.decode(DecodableErrorMock.self)
        let response = Restler.Response(data: nil, response: nil, error: TestError())
        //Act
        let error = sut.parse(Restler.Error.request(type: .unknownError, response: response))
        //Assert
        XCTAssert(error is DecodableErrorMock)
    }
    
    func testParse_multipleDecodableErrors() throws {
        //Arrange
        let sut = Restler.ErrorParser(decodingErrors: [DecodableErrorMock.self, UndecodableErrorMock.self, DecodableErrorMock.self])
        let response = Restler.Response(data: nil, response: nil, error: TestError())
        //Act
        let error = sut.parse(Restler.Error.request(type: .unknownError, response: response))
        //Assert
        guard case let .multiple(errors) = error as? Restler.Error else { return XCTFail() }
        XCTAssertEqual(errors.count, 2)
        guard case let .common(firstType, firstBase) = errors.first else { return XCTFail() }
        XCTAssertEqual(firstType, .unknownError)
        XCTAssert(firstBase is DecodableErrorMock)
        guard case let .common(secondType, secondBase) = errors.last else { return XCTFail() }
        XCTAssertEqual(secondType, .unknownError)
        XCTAssert(secondBase is DecodableErrorMock)
    }
}

// MARK: - stopDecoding(_:)
extension ErrorParserTests {
    func testStopDecoding() {
        //Arrange
        var sut = Restler.ErrorParser(decodingErrors: [DecodableErrorMock.self, DecodableErrorMock.self])
        sut.decode(DecodableErrorMock.self)
        let response = Restler.Response(data: nil, response: nil, error: TestError())
        let expectedError = Restler.Error.request(type: .unknownError, response: response)
        //Act
        sut.stopDecoding(DecodableErrorMock.self)
        //Assert
        let error = sut.parse(expectedError)
        XCTAssertEqual(error as? Restler.Error, expectedError)
    }
}
