import XCTest
@testable import Restler

final class PutInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - Void response
extension PutInterfaceIntegrationTests {
    func testPutVoid_buildingRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        // Act
        sut.put(self.endpoint)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: nil))
        XCTAssertNil(completionResult)
    }
    
    func testPutVoid_buildingRequest_encodingBody() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.VoidResult?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPutVoid_buildingRequest_encodingBodyFails() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError,
            completionResult: completionResult)
    }
    
    // MARK: Decoding success
    func testPutVoid_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.put(self.endpoint)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPutVoid_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.put(self.endpoint)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
}

// MARK: - Optional decodable response
extension PutInterfaceIntegrationTests {
    func testPutOptionalDecodable_buildingRequest_encodingBody() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPutOptionalDecodable_buildingRequest_encodingBodyFails() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError,
            completionResult: completionResult)
    }
    
    // MARK: Decoding success
    func testPutOptionalDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPutOptionalDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPutOptionalDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
}

// MARK: - Decodable response
extension PutInterfaceIntegrationTests {
    func testPutDecodable_buildingRequest_encodingBody() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .put(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPutDecodable_buildingRequest_encodingBodyFails() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError,
            completionResult: completionResult)
    }
    
    // MARK: Decoding success
    func testPutDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(decodedObject)
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error)
        guard case let .common(type, base) = restlerError else { return XCTFail(returnedError.debugDescription) }
        XCTAssertEqual(type, .invalidResponse)
        XCTAssert(base is DecodingError)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError)
    }
    
    func testPutDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(decodedObject)
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error)
        guard case let .common(type, base) = restlerError else { return XCTFail(returnedError.debugDescription) }
        XCTAssertEqual(type, .invalidResponse)
        XCTAssert(base is DecodingError)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError)
    }
    
    func testPutDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
}
