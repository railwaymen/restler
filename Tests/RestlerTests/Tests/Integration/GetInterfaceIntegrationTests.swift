import XCTest
@testable import Restler

final class GetInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - URLRequest building
extension GetInterfaceIntegrationTests {
    func testURLRequestBuilding() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .get(self.endpoint)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(requestParams.header[.contentType])
    }
    
    func testURLRequestBuilding_stringEndpoint() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .get("mock")
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertNil(requestParams.header[.contentType])
    }
    
    func testURLRequestBuilding_customHeader() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .get(self.endpoint)
            .setInHeader("hello darkness", forKey: .contentType)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: []))
        XCTAssertEqual(requestParams.header[.contentType], "hello darkness")
    }
    
    func testURLRequestBuilding_encodingQuery() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .get(self.endpoint)
            .query(SomeObject(id: 1, name: "name", double: 1.23))
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .get(query: [("id", "1"), ("name", "name"), ("double", "1.23")].toQueryItems()))
        XCTAssertEqual(requestParams.header[.contentType], "application/x-www-form-urlencoded")
    }
    
    func testGetVoid_buildingRequest_encodingQueryFails() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        // Act
        let request = sut
            .get(self.endpoint)
            .catching { returnedError = $0 }
            .query(object)
            .urlRequest()
        // Assert
        XCTAssertNil(request)
        XCTAssertEqual(self.networking.buildRequestParams.count, 0)
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError)
    }
    
    func testURLRequestBuilding_encodingDictionaryQuery() throws {
        // Arrange
        let sut = self.buildSUT()
        let header = ["id": "1", "name": "name", "double": "1.23"]
        // Act
        let request = sut
            .get(self.endpoint)
            .query(header)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        guard case let .get(query) = requestParams.method else { return XCTFail() }
        XCTAssertEqual(query.count, header.count)
        [("id", "1"), ("name", "name"), ("double", "1.23")]
            .toQueryItems()
            .forEach {
                XCTAssert(query.contains($0), "Query doesn't contain: $0")
        }
    }
}

// MARK: - Void response
extension GetInterfaceIntegrationTests {
    func testGetVoid_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.networking.makeRequestParams.last).urlSession)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    func testGetVoid_withCustomSession_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let session = URLSession()
        var completionResult: Restler.VoidResult?
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .using(session: session)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.last?.urlSession as? URLSession, session)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testGetVoid_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetVoid_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetVoid_subscribe_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .subscribe(
                onSuccess: { decodedObject = $0 },
                onFailure: { returnedError = $0 },
                onCompletion: { completionResult = $0 })
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetVoid_success_responseOnMainQueue() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.get(self.endpoint)
            .receive(on: .main)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.last?.queue, DispatchQueue.main)
        XCTAssertNil(returnedError)
        XCTAssertNotNil(decodedObject)
        XCTAssertNotNil(try XCTUnwrap(completionResult).get())
    }
    
    // MARK: Decoding Failure
    func testGetVoid_failure_onMainQueue() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .receive(on: .main)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.last?.queue, .main)
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetVoid_failure_undecodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetVoid_failure_decodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssert(returnedError is DecodableErrorMock)
    }
    
    func testGetVoid_failure_multipleErrors() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .failureDecode(UndecodableErrorMock.self)
            .failureDecode(DecodableErrorMock.self)
            .decode(Void.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
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
    func testGetOptionalDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject?.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.networking.makeRequestParams.last).urlSession)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    func testGetOptionalDecodable_withCustomSession_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let session = URLSession()
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject?.self)
            .using(session: session)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.last?.urlSession as? URLSession, session)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testGetOptionalDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetOptionalDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetOptionalDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
    
    func testGetOptionalDecodable_subscribe_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject?.self)
            .subscribe(
                onSuccess: { decodedObject = $0 },
                onFailure: { returnedError = $0 },
                onCompletion: { completionResult = $0 })
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
    
    func testGetOptionalDecodable_success_onMainQueue() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.get(self.endpoint)
            .receive(on: .main)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.last?.queue, DispatchQueue.main)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
    
    // MARK: Decoding Failure
    func testGetOptionalDecodable_failure_undecodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetOptionalDecodable_failure_decodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssert(returnedError is DecodableErrorMock)
    }
    
    func testGetOptionalDecodable_failure_multipleErrors() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .failureDecode(UndecodableErrorMock.self)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
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
    func testGetDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.networking.makeRequestParams.last).urlSession)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    func testGetDecodable_withCustomSession_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let session = URLSession()
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject.self)
            .using(session: session)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.last?.urlSession as? URLSession, session)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testGetDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(decodedObject)
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error)
        guard case let .common(type, base) = restlerError else { return XCTFail(returnedError.debugDescription) }
        XCTAssertEqual(type, .invalidResponse)
        XCTAssert(base is DecodingError)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError)
    }
    
    func testGetDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(Data()))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(decodedObject)
        let restlerError = try XCTUnwrap(returnedError as? Restler.Error)
        guard case let .common(type, base) = restlerError else { return XCTFail(returnedError.debugDescription) }
        XCTAssertEqual(type, .invalidResponse)
        XCTAssert(base is DecodingError)
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: restlerError)
    }
    
    func testGetDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
    
    func testGetDecodable_subscribe_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject.self)
            .subscribe(
                onSuccess: { decodedObject = $0 },
                onFailure: { returnedError = $0 },
                onCompletion: { completionResult = $0 })
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
    
    func testGetDecodable_success_onMainQueue() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.get(self.endpoint)
            .receive(on: .main)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.last?.queue, .main)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, expectedObject)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), expectedObject)
    }
    
    // MARK: Decoding Failure
    func testGetDecodable_failure_undecodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetDecodable_failure_decodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssert(returnedError is DecodableErrorMock)
    }
    
    func testGetDecodable_failure_multipleErrors() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var returnedError: Error?
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .failureDecode(UndecodableErrorMock.self)
            .failureDecode(DecodableErrorMock.self)
            .decode(SomeObject.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
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
    func testGetData_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data>?
        // Act
        sut.get(self.endpoint)
            .decode(Data.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testGetData_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        // Act
        sut.get(self.endpoint)
            .decode(Data.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNotNil(returnedError)
        XCTAssertNil(decodedObject)
        AssertResult(try XCTUnwrap(completionResult), errorCaseIs: Restler.Error.common(type: .invalidResponse, base: ""))
    }
    
    func testGetData_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = Data()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        // Act
        sut.get(self.endpoint)
            .decode(Data.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetData_success_someData() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        // Act
        sut.get(self.endpoint)
            .decode(Data.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetData_subscribe_success_someData() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        // Act
        sut.get(self.endpoint)
            .decode(Data.self)
            .subscribe(
                onSuccess: { decodedObject = $0 },
                onFailure: { returnedError = $0 },
                onCompletion: { completionResult = $0 })
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetData_success_onMainQueue() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data>?
        // Act
        sut.get(self.endpoint)
            .receive(on: .main)
            .decode(Data.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.last?.queue, .main)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
}

// MARK: - Optional data response
extension GetInterfaceIntegrationTests {
    func testGetOptionalData_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.DecodableResult<Data?>?
        // Act
        sut.get(self.endpoint)
            .decode(Data?.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testGetOptionalData_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        // Act
        sut.get(self.endpoint)
            .decode(Data?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertNil(decodedObject)
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testGetOptionalData_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = Data()
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        // Act
        sut.get(self.endpoint)
            .decode(Data?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetOptionalData_success_someData() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        // Act
        sut.get(self.endpoint)
            .decode(Data?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetOptionalData_subscribe_success_someData() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        // Act
        sut.get(self.endpoint)
            .decode(Data?.self)
            .subscribe(
                onSuccess: { decodedObject = $0 },
                onFailure: { returnedError = $0 },
                onCompletion: { completionResult = $0 })
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
    
    func testGetOptionalData_success_onMainQueue() throws {
        // Arrange
        let sut = self.buildSUT()
        let data = try XCTUnwrap(#"{"some": "name"}"#.data(using: .utf8))
        var returnedError: Error?
        var decodedObject: Data?
        var completionResult: Restler.DecodableResult<Data?>?
        // Act
        sut.get(self.endpoint)
            .receive(on: .main)
            .decode(Data?.self)
            .deprecatedOnFailure({ returnedError = $0 })
            .deprecatedOnSuccess({ decodedObject = $0 })
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.last?.queue, .main)
        XCTAssertNil(returnedError)
        XCTAssertEqual(decodedObject, data)
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), data)
    }
}
// swiftlint:disable:this file_length
