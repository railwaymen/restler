import XCTest
@testable import Restler

final class RestlerTests: XCTestCase {
    private let baseURLString = "https://example.com"
    private var networking: NetworkingMock!
    private var dispatchQueueManager: DispatchQueueManagerMock!
    
    private var mockURLString: String {
        self.baseURLString + "/mock"
    }
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        self.networking = NetworkingMock()
        self.dispatchQueueManager = DispatchQueueManagerMock()
    }
}

// MARK: - header set
extension RestlerTests {
    func testSetHeader_replaceAllValues() {
        //Arrange
        let sut = self.buildSUT()
        let newHeader = Restler.Header(raw: ["second": "value2"])
        self.networking.headerReturnValue = Restler.Header(raw: ["first": "value1"])
        //Act
        sut.header = newHeader
        //Assert
        XCTAssertEqual(self.networking.headerSetParams.last?.value, newHeader)
    }
    
    func testSetHeaderValue_newKey() {
        //Arrange
        let sut = self.buildSUT()
        self.networking.headerReturnValue = Restler.Header(raw: ["first": "value1"])
        //Act
        sut.header[.custom("second")] = "value2"
        //Assert
        XCTAssertEqual(self.networking.headerSetParams.last?.value.raw, ["first": "value1", "second": "value2"])
    }
    
    func testSetHeaderValue_existingKey() {
        //Arrange
        let sut = self.buildSUT()
        self.networking.headerReturnValue = Restler.Header(raw: ["first": "value1"])
        //Act
        sut.header[.custom("first")] = "value2"
        //Assert
        XCTAssertEqual(self.networking.headerSetParams.last?.value.raw, ["first": "value2"])
    }
    
    func testSetHeaderValue_nilValue() {
        //Arrange
        let sut = self.buildSUT()
        self.networking.headerReturnValue = Restler.Header(raw: ["first": "value1"])
        //Act
        sut.header[.custom("first")] = nil
        //Assert
        XCTAssertEqual(self.networking.headerSetParams.last?.value.raw, [:])
    }
    
    func testRemoveHeaderValue_existingKey() {
        //Arrange
        let sut = self.buildSUT()
        self.networking.headerReturnValue = Restler.Header(raw: ["first": "value1"])
        //Act
        let isExisting = sut.header.removeValue(forKey: .custom("first"))
        //Assert
        XCTAssertEqual(self.networking.headerSetParams.last?.value.raw, [:])
        XCTAssertTrue(isExisting)
    }
    
    func testRemoveHeaderValue_newKey() {
        //Arrange
        let sut = self.buildSUT()
        let oldHeader = ["first": "value1"]
        self.networking.headerReturnValue = Restler.Header(raw: oldHeader)
        //Act
        let isExisting = sut.header.removeValue(forKey: .custom("second"))
        //Assert
        XCTAssertEqual(self.networking.headerSetParams.last?.value.raw, oldHeader)
        XCTAssertFalse(isExisting)
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
            errorParser: Restler.ErrorParser())
    }
}
