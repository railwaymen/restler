import XCTest
@testable import Restler

class GetInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - Void response
extension GetInterfaceIntegrationTests {
    func testGetVoid_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_buildingRequest_customHeaderFields() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .setInHeader("someValue", forKey: .accept)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertEqual(requestParams.header.raw, ["Accept": "someValue"])
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: [("id", "1"), ("name", "name"), ("double", "1.23")].toQueryItems()))
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingQueryFails() throws {
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
            .get(self.endpoint)
            .query(object)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingDictionaryQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        let header = ["id": "1", "name": "name", "double": "1.23"]
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(header)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        guard case let .get(query) = requestParams.method else { return XCTFail() }
        XCTAssertEqual(query.count, header.count)
        [("id", "1"), ("name", "name"), ("double", "1.23")].toQueryItems().forEach {
            XCTAssert(query.contains($0), "Query doesn't contain: $0")
        }
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
            .body(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_buildingRequest_encodingBodyFails() throws {
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
            .get(self.endpoint)
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
    
    // MARK: Success Decoding
    func testGetVoid_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    func testGetVoid_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    // MARK: Decoding failure
    func testGetVoid_failure_undecodableError() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetVoid_failure_decodableError() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssert(returnedError is DecodableErrorMock)
    }
    
    func testGetVoid_failure_multipleErrors() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .failureDecode(UndecodableErrorMock.self)
            .failureDecode(DecodableErrorMock.self)
            .decode(Void.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        guard case let .multiple(errors) = returnedError as? Restler.Error else { return XCTFail() }
        XCTAssertEqual(errors.count, 2)
        
        guard case let .common(firstType, firstBase) = errors.first else { return XCTFail() }
        XCTAssertEqual(firstType, .unknownError)
        XCTAssert(firstBase is DecodableErrorMock)
        
        guard case let .common(secondType, secondBase) = errors.last else { return XCTFail() }
        XCTAssertEqual(secondType, .unknownError)
        XCTAssert(secondBase is DecodableErrorMock)
    }
}

// MARK: - Optional decodable response
extension GetInterfaceIntegrationTests {
    func testGetOptionalDecodable_buildingRequest_customHeaderFields() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .setInHeader("someValue", forKey: .accept)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertEqual(requestParams.header.raw, ["Accept": "someValue"])
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalDecodable_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: [("id", "1"), ("name", "name"), ("double", "1.23")].toQueryItems()))
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalDecodable_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(object)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    // MARK: Success Decoding
    func testGetOptionalDecodable_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    func testGetOptionalDecodable_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    func testGetOptionalDecodable_success_properData() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    // MARK: Decoding failure
    func testGetOptionalDecodable_failure_undecodableError() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetOptionalDecodable_failure_decodableError() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssert(returnedError is DecodableErrorMock)
    }
    
    func testGetOptionalDecodable_failure_multipleErrors() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .failureDecode(UndecodableErrorMock.self)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject?.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        guard case let .multiple(errors) = returnedError as? Restler.Error else { return XCTFail() }
        XCTAssertEqual(errors.count, 2)
        
        guard case let .common(firstType, firstBase) = errors.first else { return XCTFail() }
        XCTAssertEqual(firstType, .unknownError)
        XCTAssert(firstBase is DecodableErrorMock)
        
        guard case let .common(secondType, secondBase) = errors.last else { return XCTFail() }
        XCTAssertEqual(secondType, .unknownError)
        XCTAssert(secondBase is DecodableErrorMock)
    }
}

// MARK: - Decodable resposne
extension GetInterfaceIntegrationTests {
    func testGetDecodable_buildingRequest_customHeaderFields() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
            .setInHeader("someValue", forKey: .accept)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertEqual(requestParams.header.raw, ["Accept": "someValue"])
        XCTAssertNil(completionResult)
    }
    
    func testGetDecodable_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: [("id", "1"), ("name", "name"), ("double", "1.23")].toQueryItems()))
        XCTAssertNil(completionResult)
    }
    
    func testGetDecodable_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(object)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    // MARK: Success Decoding
    func testGetDecodable_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    func testGetDecodable_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    func testGetDecodable_success_properData() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        _ = sut
            .get(self.endpoint)
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
    
    // MARK: Decoding failure
    func testGetDecodable_failure_undecodableError() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetDecodable_failure_decodableError() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssert(returnedError is DecodableErrorMock)
    }
    
    func testGetDecodable_failure_multipleErrors() throws {
        //Arrange
        let sut = self.buildSUT()
        let error = Restler.Error.request(type: .validationError, response: Restler.Response(.init(data: nil, response: nil, error: nil)))
        var returnedError: Error?
        //Act
        _ = sut
            .get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .failureDecode(UndecodableErrorMock.self)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject.self)
            .onFailure({ returnedError = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        guard case let .multiple(errors) = returnedError as? Restler.Error else { return XCTFail() }
        XCTAssertEqual(errors.count, 2)
        
        guard case let .common(firstType, firstBase) = errors.first else { return XCTFail() }
        XCTAssertEqual(firstType, .unknownError)
        XCTAssert(firstBase is DecodableErrorMock)
        
        guard case let .common(secondType, secondBase) = errors.last else { return XCTFail() }
        XCTAssertEqual(secondType, .unknownError)
        XCTAssert(secondBase is DecodableErrorMock)
    }
}

// MARK: - Data response
extension GetInterfaceIntegrationTests {
    func testGetData_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(completionResult)
    }
    
    func testGetData_buildingRequest_customHeaderFields() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .setInHeader("someValue", forKey: .accept)
            .decode(Data.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertEqual(requestParams.header.raw, ["Accept": "someValue"])
        XCTAssertNil(completionResult)
    }
    
    func testGetData_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Data.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: [("id", "1"), ("name", "name"), ("double", "1.23")].toQueryItems()))
        XCTAssertNil(completionResult)
    }
    
    func testGetData_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(object)
            .decode(Data.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testGetData_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .body(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Data.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(completionResult)
    }
    
    func testGetData_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .body(object)
            .decode(Data.self)
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
    
    // MARK: Success Decoding
    func testGetData_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertNotNil(returnedError)
        XCTAssertNil(decodedObject)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.common(type: .invalidResponse, base: ""))
    }
    
    func testGetData_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = Data()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data.self)
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
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetData_success_someData() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data.self)
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
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
}

// MARK: - Optional data response
extension GetInterfaceIntegrationTests {
    func testGetOptionalData_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalData_buildingRequest_customHeaderFields() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .setInHeader("someValue", forKey: .accept)
            .decode(Data?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertEqual(requestParams.header.raw, ["Accept": "someValue"])
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalData_buildingRequest_encodingQuery() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Data?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: [("id", "1"), ("name", "name"), ("double", "1.23")].toQueryItems()))
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalData_buildingRequest_encodingQueryFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .query(object)
            .decode(Data?.self)
            .onFailure({ returnedError = $0 })
            .onSuccess({ decodedObject = $0 })
            .onCompletion({ completionResult = $0 })
            .start()
        self.dispatchQueueManager.performParams.forEach { $0.action() }
        //Assert
        XCTAssertEqual(self.dispatchQueueManager.performParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 0)
        XCTAssertNil(decodedObject)
        try self.assertThrowsEncodingError(expected: expectedError, returnedError: returnedError, completionResult: completionResult)
    }
    
    func testGetOptionalData_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .body(SomeObject(id: 1, name: "name", double: 1.23))
            .decode(Data?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalData_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .body(object)
            .decode(Data?.self)
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
    
    // MARK: Success Decoding
    func testGetOptionalData_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data?.self)
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
    
    func testGetOptionalData_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = Data()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data?.self)
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
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetOptionalData_success_someData() throws {
        //Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        //Act
        _ = sut
            .get(self.endpoint)
            .decode(Data?.self)
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
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
}

private extension Array where Element == (String, String) {
    func toQueryItems() -> [URLQueryItem] {
        self.map { URLQueryItem(name: $0, value: $1) }
    }
}
