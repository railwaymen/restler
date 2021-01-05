import XCTest
@testable import RestlerCore

class InterfaceIntegrationTestsBase: XCTestCase {
    let baseURL = URL(string: "https://example.com")!
    let endpoint = EndpointMock.mock
    var networking: NetworkingMock!
    var dispatchQueueManager: DispatchQueueManagerMock!
    var eventLogger: EventLoggerMock!
    
    var mockURLString: String {
        self.baseURL.absoluteString + "/mock"
    }
    
    var expectedRequest: URLRequest { URLRequest(url: self.baseURL) }
    
    override func setUp() {
        super.setUp()
        self.networking = NetworkingMock()
        self.dispatchQueueManager = DispatchQueueManagerMock()
        self.eventLogger = EventLoggerMock()
        
        self.networking.buildRequestReturnValue = self.expectedRequest
    }
    
    // MARK: - Internal
    func buildSUT() -> Restler {
        Restler(
            baseURL: self.baseURL,
            networking: self.networking,
            dispatchQueueManager: self.dispatchQueueManager,
            encoder: JSONEncoder(),
            decoder: JSONDecoder(),
            errorParser: Restler.ErrorParser(),
            eventLogger: self.eventLogger)
    }
    
    func assertThrowsEncodingError(
        expected: TestError,
        returnedError: Error?,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error, file: file, line: line)
        guard case let .common(type, base) = restlerError else {
            return XCTFail("Error thrown is not common error", file: file, line: line)
        }
        XCTAssertEqual(base as? TestError, expected, file: file, line: line)
        XCTAssertEqual(type, Restler.ErrorType.invalidParameters, file: file, line: line)
    }
}
