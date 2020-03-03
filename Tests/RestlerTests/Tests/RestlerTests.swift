import XCTest
@testable import Restler

final class RestlerTests: XCTestCase {
    private var networking: NetworkingMock!
    private var dispatchQueueManager: DispatchQueueManagerMock!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        self.networking = NetworkingMock()
        self.dispatchQueueManager = DispatchQueueManagerMock()
    }
}

// MARK: - get(url:query:expectedType:completion:)
extension RestlerTests {
    func testGet_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let queryParameters = ["some": "value"]
        var completionResult: Result<SomeObject, Error>?
        //Act
        sut.get(url: url, query: queryParameters) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .get(query: queryParameters))
    }
    
    func testGet_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        var completionResult: Result<SomeObject, Error>?
        //Act
        try XCTUnwrap(sut).get(url: url, query: [:]) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testGet_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        var completionResult: Result<SomeObject, Error>?
        //Act
        sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testGet_invalidResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        var completionResult: Result<SomeObject, Error>?
        //Act
        sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testGet_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        var completionResult: Result<SomeObject, Error>?
        //Act
        sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
}

// MARK: - post(url:content:expectedType:completion:)
extension RestlerTests {
    func testPost_encodingThrows() throws {
        //Arrange
        let encoderMock = JSONEncoderThrowingMock()
        let sut = self.buildSUT(encoder: encoderMock)
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        var completionResult: Result<SomeObject, Error>?
        //Act
        XCTAssertThrowsError(
            try sut.post(url: url, content: content) { result in
                completionResult = result
        }) { error in
            XCTAssertEqual(error as? TestError, encoderMock.thrownError)
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
    }
    
    func testPost_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        var completionResult: Result<SomeObject, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .post(content: try JSONEncoder().encode(content)))
    }
    
    func testPost_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        var completionResult: Result<SomeObject, Error>?
        //Act
        try XCTUnwrap(sut).post(url: url, content: content) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPost_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        var completionResult: Result<SomeObject, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPost_invalidResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        var completionResult: Result<SomeObject, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testPost_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        var completionResult: Result<SomeObject, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
}

// MARK: - post(url:content:completion:)
extension RestlerTests {
    func testPostIgnoringResponse_encodingThrows() throws {
        //Arrange
        let encoderMock = JSONEncoderThrowingMock()
        let sut = self.buildSUT(encoder: encoderMock)
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        var completionResult: Result<Void, Error>?
        //Act
        XCTAssertThrowsError(
            try sut.post(url: url, content: content) { result in
                completionResult = result
        }) { error in
            XCTAssertEqual(error as? TestError, encoderMock.thrownError)
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
    }
    
    func testPostIgnoringResponse_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        var completionResult: Result<Void, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .post(content: try JSONEncoder().encode(content)))
    }
    
    func testPostIgnoringResponse_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        var completionResult: Result<Void, Error>?
        //Act
        try XCTUnwrap(sut).post(url: url, content: content) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPostIgnoringResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        var completionResult: Result<Void, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPostIgnoringResponse_invalidResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        var completionResult: Result<Void, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPostIgnoringResponse_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        var completionResult: Result<Void, Error>?
        //Act
        try sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
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
    private func buildSUT(encoder: JSONEncoderType = JSONEncoder()) -> Restler {
        return Restler(
            networking: self.networking,
            dispatchQueueManager: self.dispatchQueueManager,
            encoder: encoder,
            decoder: JSONDecoder())
    }
}
