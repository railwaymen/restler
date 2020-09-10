import XCTest
@testable import Restler

final class RestlerTests: XCTestCase {
    private let baseURLString = "https://example.com"
    private var networking: NetworkingMock!
    private var dispatchQueueManager: DispatchQueueManagerMock!
    private var eventLogger: EventLoggerMock!
    
    private var mockURLString: String {
        self.baseURLString + "/mock"
    }
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        self.networking = NetworkingMock()
        self.dispatchQueueManager = DispatchQueueManagerMock()
        self.eventLogger = EventLoggerMock()
    }
}

// MARK: - Private
extension RestlerTests {
    private func buildSUT(encoder: RestlerJSONEncoderType = JSONEncoder()) -> Restler {
        return Restler(
            baseURL: URL(string: self.baseURLString)!,
            networking: self.networking,
            dispatchQueueManager: self.dispatchQueueManager,
            encoder: encoder,
            decoder: JSONDecoder(),
            errorParser: Restler.ErrorParser(),
            eventLogger: self.eventLogger)
    }
}
