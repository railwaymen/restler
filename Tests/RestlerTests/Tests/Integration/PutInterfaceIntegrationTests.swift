import XCTest
@testable import RestlerCore

final class PutInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - URLRequest building
extension PutInterfaceIntegrationTests {
    func testURLRequestBuilding_withoutBody() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .put(self.endpoint)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .put)
        XCTAssertNil(requestParams.requestData.header[.contentType])
        XCTAssertNil(requestParams.requestData.content)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
    
    func testURLRequestBuilding_withoutBody_customHeader() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .put(self.endpoint)
            .setInHeader("hello_darkness", forKey: .contentType)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .put)
        XCTAssertEqual(requestParams.requestData.header[.contentType], "hello_darkness")
        XCTAssertNil(requestParams.requestData.content)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
    
    func testURLRequestBuilding_encodingBody() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        // Act
        let request = sut
            .put(self.endpoint)
            .body(object)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .put)
        XCTAssertEqual(requestParams.requestData.header[.contentType], "application/json")
        XCTAssertEqual(requestParams.requestData.content, data)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
    
    func testURLRequestBuilding_encodingBodyFails() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Restler.Error?
        // Act
        let request = sut
            .put(self.endpoint)
            .catching { returnedError = $0 }
            .body(object)
            .urlRequest()
        // Assert
        XCTAssertNil(request)
        XCTAssertEqual(self.networking.buildRequestParams.count, 0)
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError)
    }
}

// MARK: - Void response
extension PutInterfaceIntegrationTests {
    func testPutVoid_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        // Act
        sut.put(self.endpoint)
            .decode(Void.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testPutVoid_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.put(self.endpoint)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
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
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
}

// MARK: - Optional decodable response
extension PutInterfaceIntegrationTests {
    func testPutOptionalDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testPutOptionalDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
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
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
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
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
}

// MARK: - Decodable response
extension PutInterfaceIntegrationTests {
    func testPutDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.put(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testPutDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.put(self.endpoint)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
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
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
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
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
}
