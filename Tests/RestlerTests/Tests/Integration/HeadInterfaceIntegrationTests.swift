import XCTest
@testable import RestlerCore

final class HeadInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

// MARK: - URLRequest building
extension HeadInterfaceIntegrationTests {
    func testURLRequestBuilding() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        let request = sut
            .head(self.endpoint)
            .urlRequest()
        // Assert
        XCTAssertEqual(request, expectedRequest)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.first)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .head)
        XCTAssertNil(requestParams.requestData.header[.contentType])
        XCTAssertNil(requestParams.requestData.content)
        XCTAssertEqual(requestParams.requestData.query, [])
    }
}

// MARK: - Void response
extension HeadInterfaceIntegrationTests {
    func testHead_buildingRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Restler.VoidResult?
        // Act
        sut.head(self.endpoint)
            .decode(Void.self)
            .deprecatedOnCompletion({ completionResult = $0 })
            .deprecatedStart()
        // Assert
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(completionResult)
    }
    
    // MARK: Decoding Success
    func testHead_success_nil() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.head(self.endpoint)
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

    func testHead_success_emptyData() throws {
        // Arrange
        let sut = self.buildSUT()
        var returnedError: Error?
        var decodedObject: Void?
        var completionResult: Restler.VoidResult?
        // Act
        sut.head(self.endpoint)
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
