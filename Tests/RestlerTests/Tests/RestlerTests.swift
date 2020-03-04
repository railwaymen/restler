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

// MARK: - get(url:query:expectedType:completion:)
extension RestlerTests {
    func testGet_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let queryParameters = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.get(url: url, query: queryParameters) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .get(query: queryParameters))
        XCTAssertNil(completionResult)
    }
    
    func testGet_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = try XCTUnwrap(sut).get(url: url, query: [:]) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testGet_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testGet_invalidResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
    
    // MARK: Optional expected type
    func testGetOptionalResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testGetOptionalResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetOptionalResponse_emptyResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetOptionalResponse_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
}

// MARK: - get(url:query:completion:)
extension RestlerTests {
    func testGetIgnoringResponse_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let queryParameters = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.get(url: url, query: queryParameters) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .get(query: queryParameters))
        XCTAssertNil(completionResult)
    }
    
    func testGetIgnoringResponse_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = try XCTUnwrap(sut).get(url: url, query: [:]) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testGetIgnoringResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testGetIgnoringResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetIgnoringResponse_success() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.get(url: url, query: [:]) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(task)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: encoderMock.thrownError)
    }
    
    func testPost_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .post(content: try JSONEncoder().encode(content)))
        XCTAssertNil(completionResult)
    }
    
    func testPost_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = try XCTUnwrap(sut).post(url: url, content: content) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPost_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testPost_invalidResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
    
    // MARK: Optional expected type
    func testPostOptionalResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPostOptionalResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPostOptionalResponse_emptyResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPostOptionalResponse_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(task)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: encoderMock.thrownError)
    }
    
    func testPostIgnoringResponse_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .post(content: try JSONEncoder().encode(content)))
        XCTAssertNil(completionResult)
    }
    
    func testPostIgnoringResponse_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = try XCTUnwrap(sut).post(url: url, content: content) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPostIgnoringResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPostIgnoringResponse_emptyResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
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
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.post(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
}

// MARK: - put(url:content:expectedType:completion:)
extension RestlerTests {
    func testPut_encodingThrows() throws {
        //Arrange
        let encoderMock = JSONEncoderThrowingMock()
        let sut = self.buildSUT(encoder: encoderMock)
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(task)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: encoderMock.thrownError)
    }
    
    func testPut_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .put(content: try JSONEncoder().encode(content)))
        XCTAssertNil(completionResult)
    }
    
    func testPut_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = try XCTUnwrap(sut).put(url: url, content: content) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPut_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPut_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testPut_invalidResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testPut_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
    
    // MARK: Optional expected type
    func testPutOptionalResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPutOptionalResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPutOptionalResponse_emptyResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPutOptionalResponse_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
}

// MARK: - put(url:content:completion:)
extension RestlerTests {
    func testPutIgnoringResponse_encodingThrows() throws {
        //Arrange
        let encoderMock = JSONEncoderThrowingMock()
        let sut = self.buildSUT(encoder: encoderMock)
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertNil(task)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: encoderMock.thrownError)
    }
    
    func testPutIgnoringResponse_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .put(content: try JSONEncoder().encode(content)))
        XCTAssertNil(completionResult)
    }
    
    func testPutIgnoringResponse_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = try XCTUnwrap(sut).put(url: url, content: content) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPutIgnoringResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testPutIgnoringResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPutIgnoringResponse_emptyResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPutIgnoringResponse_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = ["some": "value"]
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.put(url: url, content: content) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
}

// MARK: - delete(url:expectedType:completion:)
extension RestlerTests {
    func testDelete_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .delete)
        XCTAssertNil(completionResult)
    }
    
    func testDelete_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = try XCTUnwrap(sut).delete(url: url) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testDelete_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testDelete_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testDelete_invalidResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.invalidResponse)
    }
    
    func testDelete_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
    
    // MARK: Optional expected type
    func testDeleteOptionalResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testDeleteOptionalResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteOptionalResponse_emptyResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteOptionalResponse_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), SomeObject(id: 1, name: "Object"))
    }
}

// MARK: - delete(url:expectedType:completion:)
extension RestlerTests {
    func testDeleteIgnoringResponse_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.first?.url, url)
        XCTAssertEqual(self.networking.makeRequestParams.first?.method, .delete)
        XCTAssertNil(completionResult)
    }
    
    func testDeleteIgnoringResponse_selfDeinitialized() throws {
        //Arrange
        var sut: Restler? = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = try XCTUnwrap(sut).delete(url: url) { result in
            completionResult = result
        }
        sut = nil
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testDeleteIgnoringResponse_failure() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let error = TestError()
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.failure(error))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: error)
    }
    
    func testDeleteIgnoringResponse_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(nil))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteIgnoringResponse_emptyResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(Data()))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteIgnoringResponse_decodesObject() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let response = try JSONSerialization.data(withJSONObject: ["id": 1, "name": "Object"], options: .prettyPrinted)
        let returnedTask = Restler.Task(task: URLSessionDataTaskMock())
        self.networking.makeRequestReturnValue = returnedTask
        var completionResult: Restler.VoidResult?
        //Act
        let task = sut.delete(url: url) { result in
            completionResult = result
        }
        try XCTUnwrap(self.networking.makeRequestParams.last).completion(.success(response))
        try XCTUnwrap(self.dispatchQueueManager.performParams.last).action()
        //Assert
        XCTAssertEqual(task, returnedTask)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.thread, .main)
        XCTAssertEqual(self.dispatchQueueManager.performParams.last?.syncType, .async)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
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
