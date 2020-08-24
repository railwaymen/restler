import XCTest
@testable import Restler

final class PostInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - Void response
extension PostInterfaceIntegrationTests {
    func testPostVoid_buildingRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        //Act
        sut.post(self.endpoint)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: nil))
        XCTAssertNil(requestParams.header[.contentType])
        XCTAssertNil(completionResult)
    }
    
    func testPostVoid_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.VoidResult?
        //Act
        sut.post(self.endpoint)
            .body(object)
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: data))
        XCTAssertEqual(requestParams.header[.contentType], "application/json")
        XCTAssertNil(completionResult)
    }
    
    func testPostVoid_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        sut.post(self.endpoint)
            .body(object)
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
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError,
            completionResult: completionResult)
    }
    
    func testPostVoid_buildingRequest_encodingMultipart() throws {
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
        var completionResult: Restler.VoidResult?
        //Act
        sut.post(self.endpoint)
            .multipart(object, boundary: "boundary")
            .decode(Void.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: data))
        XCTAssertEqual(requestParams.header[.contentType], "multipart/form-data; charset=utf-8; boundary=boundary")
        XCTAssertNil(completionResult)
    }
    
    func testPostVoid_buildingRequest_encodingMultipartFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        sut.post(self.endpoint)
            .multipart(object)
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
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError,
            completionResult: completionResult)
    }
    
    // MARK: Decoding success
    func testPostVoid_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        sut.post(self.endpoint)
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
    
    func testPostVoid_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        //Act
        sut.post(self.endpoint)
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
extension PostInterfaceIntegrationTests {
    func testPostOptionalDecodable_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        sut.post(self.endpoint)
            .body(object)
            .decode(SomeObject?.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPostOptionalDecodable_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        sut.post(self.endpoint)
            .body(object)
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
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError,
            completionResult: completionResult)
    }
    
    // MARK: Decoding success
    func testPostOptionalDecodable_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        sut.post(self.endpoint)
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
    
    func testPostOptionalDecodable_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        sut.post(self.endpoint)
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
    
    func testPostOptionalDecodable_success_properData() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject?>?
        //Act
        sut.post(self.endpoint)
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
extension PostInterfaceIntegrationTests {
    func testPostDecodable_buildingRequest_encodingBody() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = SomeObject(id: 1, name: "name", double: 1.23)
        let data = try JSONEncoder().encode(object)
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        sut.post(self.endpoint)
            .body(object)
            .decode(SomeObject.self)
            .onCompletion({ completionResult = $0 })
            .start()
        //Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.makeRequestParams.first)
        XCTAssertEqual(requestParams.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.method, .post(content: data))
        XCTAssertNil(completionResult)
    }
    
    func testPostDecodable_buildingRequest_encodingBodyFails() throws {
        //Arrange
        let sut = self.buildSUT()
        let object = ThrowingObject()
        let expectedError = TestError()
        object.thrownError = expectedError
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        sut.post(self.endpoint)
            .body(object)
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
        try self.assertThrowsEncodingError(
            expected: expectedError,
            returnedError: returnedError,
            completionResult: completionResult)
    }
    
    // MARK: Decoding success
    func testPostDecodable_success_nil() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        sut.post(self.endpoint)
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
    
    func testPostDecodable_success_emptyData() throws {
        //Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        sut.post(self.endpoint)
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
    
    func testPostDecodable_success_properData() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var returnedError: Error?
        var decodedObject: SomeObject?
        var completionResult: Restler.DecodableResult<SomeObject>?
        //Act
        sut.post(self.endpoint)
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
// swiftlint:disable:this file_length
