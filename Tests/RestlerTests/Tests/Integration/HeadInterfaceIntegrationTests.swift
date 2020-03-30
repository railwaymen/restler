import XCTest
@testable import Restler

class HeadInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - Void response
extension HeadInterfaceIntegrationTests  {
    func testHead_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .head)
        XCTAssertNil(completionResult)
    }

    func testHead_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .query(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .head)
        XCTAssertNil(completionResult)
    }

    func testHead_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .query(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 0)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(completionResult)
    }

    func testHead_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .body(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .head)
        XCTAssertNil(completionResult)
    }

    func testHead_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 0)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(completionResult)
    }

    func testHead_buildingRequest_encodingMultipart() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "some", double: 1.23)
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .multipart(object)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .head)
        XCTAssertNil(requestParams.header[.contentType])
        XCTAssertNil(completionResult)
    }

    func testHead_buildingRequest_encodingMultipartFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .multipart(object)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .head)
        XCTAssertNil(requestParams.header[.contentType])
        XCTAssertNil(completionResult)
    }

    // MARK: Decoding success
    func testHead_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }

    func testHead_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .head(self.endpoint)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
}
