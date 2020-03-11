import XCTest
@testable import Restler

class InterfaceIntegrationTestsBase: XCTestCase {
    let baseURL = URL(string: "https://example.com")!
    let endpoint = EndpointMock.mock
    var networking: NetworkingMock!
    var dispatchQueueManager: DispatchQueueManagerMock!
    
    var mockURLString: String {
        return self.baseURL.absoluteString + "/mock"
    }
    
    override func setUp() {
        super.setUp()
        self.networking = NetworkingMock()
        self.dispatchQueueManager = DispatchQueueManagerMock()
    }
    
    // MARK: - Internal
    func buildSUT() -> Restler {
        return Restler(
            baseURL: self.baseURL,
            networking: self.networking,
            dispatchQueueManager: self.dispatchQueueManager,
            encoder: JSONEncoder(),
            decoder: JSONDecoder(),
            errorParser: Restler.ErrorParser())
    }
    
    func assertThrowsEncodingError<T>(
        expected: TestError,
        returnedError: Error?,
        completionResult: Result<T, Error>?,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error, file: file, line: line)
        guard case let .multiple(errors) = restlerError else { return XCTFail("Returned error is not multiple error", file: file, line: line) }
        XCTAssertEqual(errors.count, 1, file: file, line: line)
        guard case let .common(type, base) = errors.first else { return XCTFail("Error thrown is not common error", file: file, line: line) }
        XCTAssertEqual(base as? TestError, expected, file: file, line: line)
        XCTAssertEqual(type, Restler.ErrorType.invalidParameters, file: file, line: line)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError, file: file, line: line)
    }
}
