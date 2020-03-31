import XCTest
@testable import Restler

class DeleteInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - Void response
extension DeleteInterfaceIntegrationTests {
    func testDeleteVoid_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .delete)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding success
    func testDeleteVoid_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .delete(self.endpoint)
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
    
    func testDeleteVoid_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .delete(self.endpoint)
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

// MARK: - Optional decodable response
extension DeleteInterfaceIntegrationTests {
    func testDeleteOptionalDecodable_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .delete)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding success
    func testDeleteOptionalDecodable_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject?.self)
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
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteOptionalDecodable_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject?.self)
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
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testDeleteOptionalDecodable_success_properData() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
}

// MARK: - Decodable response
extension DeleteInterfaceIntegrationTests {
    func testDeleteDecodable_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .delete)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding success
    func testDeleteDecodable_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(decodedObject)
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error)
        guard case let .common(type, base) = restlerError else { return XCTFail(returnedError.debugDescription) }
        XCTAssertEqual(type, .invalidResponse)
        XCTAssert(base is DecodingError)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError)
    }
    
    func testDeleteDecodable_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(decodedObject)
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error)
        guard case let .common(type, base) = restlerError else { return XCTFail(returnedError.debugDescription) }
        XCTAssertEqual(type, .invalidResponse)
        XCTAssert(base is DecodingError)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError)
    }
    
    func testDeleteDecodable_success_properData() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .delete(self.endpoint)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
}
