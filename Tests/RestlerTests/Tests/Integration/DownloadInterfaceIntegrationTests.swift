import XCTest
@testable import RestlerCore

final class DownloadInterfaceIntegrationTests: InterfaceIntegrationTestsBase {}

extension DownloadInterfaceIntegrationTests {
    func testDownloadInterface_buildsProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedURL = self.baseURL.appendingPathComponent("random/sio3f")
        self.networking.buildRequestReturnValue = URLRequest(url: expectedURL)
        // Act
        sut.get(self.endpoint)
            .requestDownload()
            .subscribe()
        // Assert
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertEqual(self.networking.buildRequestParams.last?.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(self.networking.downloadRequestParams.count, 1)
        XCTAssertEqual(self.networking.downloadRequestParams.last?.urlRequest.url?.absoluteString, expectedURL.absoluteString)
    }
    
    func testDownloadInterface_withQuery_buildsProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        // Act
        sut.get(self.endpoint)
            .query(["user": "yes"])
            .requestDownload()
            .subscribe()
        // Assert
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        let requestParams = try XCTUnwrap(self.networking.buildRequestParams.last)
        XCTAssertEqual(requestParams.requestData.url.absoluteString, self.mockURLString)
        XCTAssertEqual(requestParams.requestData.method, .get)
        XCTAssertEqual(requestParams.requestData.query, [URLQueryItem(name: "user", value: "yes")])
    }
    
    func testDownloadInterface_usingResumeData() throws {
        // Arrange
        let sut = self.buildSUT()
        let resumeData = try XCTUnwrap("thumbnail".data(using: .utf8))
        // Act
        sut.get(self.endpoint)
            .resumeData(resumeData)
            .requestDownload()
            .subscribe()
        // Assert
        XCTAssertEqual(self.networking.downloadRequestParams.count, 1)
        XCTAssertEqual(self.networking.downloadRequestParams.last?.resumeData, resumeData)
    }
    
    func testDownloadInterface_callsProgressHandler() throws {
        // Arrange
        let sut = self.buildSUT()
        var progressHandlerCalledCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .requestDownload()
            .subscribe(onProgress: { _ in progressHandlerCalledCount += 1 })
        // Assert
        self.networking.downloadRequestParams.last?.progressHandler(RestlerDownloadTaskMock())
        XCTAssertEqual(progressHandlerCalledCount, 1)
    }
    
    func testDownloadInterface_callsCompletionSuccessHandler() throws {
        // Arrange
        let sut = self.buildSUT()
        var successHandlerCalledCount: Int = 0
        var errorHandlerCalledCount: Int = 0
        var completionHandlerCalledCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .requestDownload()
            .subscribe(
                onSuccess: { _ in successHandlerCalledCount += 1 },
                onError: { _ in errorHandlerCalledCount += 1 },
                onCompletion: { _ in completionHandlerCalledCount += 1 })
        // Assert
        self.networking.downloadRequestParams.last?.completionHandler(.success(self.baseURL))
        XCTAssertEqual(successHandlerCalledCount, 1)
        XCTAssertEqual(errorHandlerCalledCount, 0)
        XCTAssertEqual(completionHandlerCalledCount, 1)
    }
    
    func testDownloadInterface_callsCompletionFailureHandler() throws {
        // Arrange
        let sut = self.buildSUT()
        var successHandlerCalledCount: Int = 0
        var errorHandlerCalledCount: Int = 0
        var completionHandlerCalledCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .requestDownload()
            .subscribe(
                onSuccess: { _ in successHandlerCalledCount += 1 },
                onError: { _ in errorHandlerCalledCount += 1 },
                onCompletion: { _ in completionHandlerCalledCount += 1 })
        // Assert
        self.networking.downloadRequestParams.last?.completionHandler(.failure(.common(type: .notFound, base: TestError())))
        XCTAssertEqual(successHandlerCalledCount, 0)
        XCTAssertEqual(errorHandlerCalledCount, 1)
        XCTAssertEqual(completionHandlerCalledCount, 1)
    }
}
