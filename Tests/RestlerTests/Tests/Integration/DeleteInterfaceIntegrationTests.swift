import XCTest
@testable import RestlerCore

final class DeleteInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - URLRequest building
extension DeleteInterfaceIntegrationTests {
    func testURLRequestBuilding() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .delete(self.endpoint)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .delete)
        XCTAssertNil(requestParams.requestData.header[.contentType])
        XCTAssertNil(requestParams.requestData.content)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
    
    func testURLRequestBuilding_customHeader() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .delete(self.endpoint)
            .setInHeader("hello_darkness", forKey: .contentType)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .delete)
        XCTAssertEqual(requestParams.requestData.header[.contentType], "hello_darkness")
        XCTAssertNil(requestParams.requestData.content)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
    
    // MARK: - Encoding Body
    func testURLRequestBuilding_encodingBody() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        // Act
        let request = sut
            .delete(self.endpoint)
            .body(object)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .delete)
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
        var returnedError: Error?
        // Act
        let request = sut
            .post(self.endpoint)
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
extension DeleteInterfaceIntegrationTests {
    func testDeleteVoid_buildingRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        // Act
        sut.delete(self.endpoint)
            .decode(Void.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testDeleteVoid_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.delete(self.endpoint)
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
    
    func testDeleteVoid_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.delete(self.endpoint)
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
extension DeleteInterfaceIntegrationTests {
    func testDeleteOptionalDecodable_buildingRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.delete(self.endpoint)
            .decode(SomeObject?.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testDeleteOptionalDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.delete(self.endpoint)
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
    
    func testDeleteOptionalDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.delete(self.endpoint)
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
    
    func testDeleteOptionalDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.delete(self.endpoint)
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
extension DeleteInterfaceIntegrationTests {
    func testDeleteDecodable_buildingRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.delete(self.endpoint)
            .decode(SomeObject.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testDeleteDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.delete(self.endpoint)
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
    
    func testDeleteDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.delete(self.endpoint)
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
    
    func testDeleteDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.delete(self.endpoint)
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
