import XCTest
@testable import RestlerCore

final class PostInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - URLRequest building
extension PostInterfaceIntegrationTests {
    func testURLRequestBuilding_withoutBody() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .post(self.endpoint)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .post)
        XCTAssertNil(requestParams.requestData.header[.contentType])
        XCTAssertNil(requestParams.requestData.content)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
    
    func testURLRequestBuilding_withoutBody_customHeader() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .post(self.endpoint)
            .setInHeader("hello_darkness", forKey: .contentType)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .post)
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
            .post(self.endpoint)
            .body(object)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .post)
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
    
    func testURLRequestBuilding_encodingMultipart() throws {
        //Arrange
        let sut = self.buildSUT()
        let imageString = "some image data"
        let object = ImageEncoder(
            id: 1,
            title: "My Image",
            image: Restler.MultipartObject(
                filename: "image.png",
                contentType: "image/png",
                body: imageString.data(using: .utf8)!))
        let data = """
            --boundary\r\n\
            Content-Disposition: form-data; name="id"\r\n\
            \r\n\
            1\r\n\
            --boundary\r\n\
            Content-Disposition: form-data; name="title"\r\n\
            \r\n\
            My Image\r\n\
            --boundary\r\n\
            Content-Disposition: form-data; name="image"; filename="image.png"\r\n\
            Content-Type: image/png\r\n\
            \r\n\
            \(imageString)\r\n\
            --boundary--\r\n
            """.data(using: .utf8)!
        // Act
        let request = sut
            .post(self.endpoint)
            .multipart(object, boundary: "boundary")
            .urlRequest()
        //Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .post)
        XCTAssertEqual(requestParams.requestData.header[.contentType], "multipart/form-data; charset=utf-8; boundary=boundary")
        XCTAssertEqual(requestParams.requestData.content, data)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
    
    func testURLRequestBuilding_encodingMultipartFails() throws {
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
            .multipart(object)
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
extension PostInterfaceIntegrationTests {
    func testPostVoid_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        // Act
        sut.post(self.endpoint)
            .decode(Void.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testPostVoid_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.post(self.endpoint)
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
    
    func testPostVoid_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.post(self.endpoint)
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
extension PostInterfaceIntegrationTests {
    func testPostOptionalDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.post(self.endpoint)
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
    func testPostOptionalDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.post(self.endpoint)
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
    
    func testPostOptionalDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.post(self.endpoint)
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
    
    func testPostOptionalDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        // Act
        sut.post(self.endpoint)
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
extension PostInterfaceIntegrationTests {
    func testPostDecodable_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.post(self.endpoint)
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
    func testPostDecodable_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.post(self.endpoint)
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
    
    func testPostDecodable_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.post(self.endpoint)
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
    
    func testPostDecodable_success_properData() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        // Act
        sut.post(self.endpoint)
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
