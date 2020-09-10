import XCTest
@testable import Restler

final class PatchInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - URLRequest building
extension PatchInterfaceIntegrationTests {
    func testURLRequestBuilding_withoutBody() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .patch(self.endpoint)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .patch(content: nil))
        XCTAssertNil(requestParams.header[.contentType])
    }
    
    func testURLRequestBuilding_withoutBody_customHeader() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .patch(self.endpoint)
            .setInHeader("hello darkness", forKey: .contentType)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .patch(content: nil))
        XCTAssertEqual(requestParams.header[.contentType], "hello darkness")
    }
    
    func testURLRequestBuilding_encodingBody() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        // Act
        let request = sut
            .patch(self.endpoint)
            .body(object)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .patch(content: data))
        XCTAssertEqual(requestParams.header[.contentType], "application/json")
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
            .patch(self.endpoint)
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
extension PatchInterfaceIntegrationTests {
    func testPatchVoid_buildingRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        // Act
        sut.patch(self.endpoint)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testPatchVoid_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.patch(self.endpoint)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPatchVoid_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.patch(self.endpoint)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
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
extension PatchInterfaceIntegrationTests {
    func testPatchOptionalDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.patch(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testPatchOptionalDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.patch(self.endpoint)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPatchOptionalDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.patch(self.endpoint)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testPatchOptionalDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.patch(self.endpoint)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
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
extension PatchInterfaceIntegrationTests {
    func testPatchDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.patch(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testPatchDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.patch(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
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
    
    func testPatchDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.patch(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
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
    
    func testPatchDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.patch(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
}
