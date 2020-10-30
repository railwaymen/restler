import XCTest
@testable import RestlerCore

final class NetworkingTests: XCTestCase {
    private var session: URLSessionMock!
    private var eventLogger: EventLoggerMock!
    
    private var cacheModification: (inout URLRequest) -> Void = { request in
        request.cachePolicy = .reloadIgnoringCacheData
    }
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        self.session = URLSessionMock()
        self.eventLogger = EventLoggerMock()
    }
}

// MARK: - makeRequest(urlRequest:completion:)
extension NetworkingTests {
    func testMakeRequest_makesProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        var completionResult: DataResult?
        // Act
        let task = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        // Assert
        XCTAssertEqual(self.session.dataTaskParams.count, 1)
        let request = try XCTUnwrap(self.session.dataTaskParams.last?.request)
        XCTAssertEqual(urlRequest, request)
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.session.dataTaskReturnValue.resumeParams.count, 1)
        XCTAssertNotNil(task)
    }
    
    func testMakeRequest_providedCustomSession_makesProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let session = URLSessionMock()
        var completionResult: DataResult?
        // Act
        let task = sut.makeRequest(urlRequest: urlRequest, urlSession: session, eventLogger: eventLogger) { result in
            completionResult = result
        }
        // Assert
        XCTAssertEqual(self.session.dataTaskParams.count, 0)
        XCTAssertEqual(session.dataTaskParams.count, 1)
        let request = try XCTUnwrap(session.dataTaskParams.last?.request)
        XCTAssertEqual(urlRequest, request)
        XCTAssertNil(completionResult)
        XCTAssertEqual(session.dataTaskReturnValue.resumeParams.count, 1)
        XCTAssertNotNil(task)
    }
    
    func testMakeRequest_successfulResponse() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        let responseData = Data()
        let response = HTTPRequestResponse(data: responseData, response: mockResponse, error: nil)
        var completionResult: DataResult?
        // Act
        _ = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        // Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), responseData)
    }
    
    func testMakeRequest_noResponse() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let response = HTTPRequestResponse(data: Data(), response: nil, error: nil)
        var completionResult: DataResult?
        // Act
        _ = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        // Assert
        let expectedError = Restler.Error.request(type: .unknownError, response: Restler.Response(response))
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: expectedError)
    }
    
    func testMakeRequest_notFoundResponse() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = false
        mockResponse.statusCodeReturnValue = 404
        let response = HTTPRequestResponse(data: Data(), response: mockResponse, error: nil)
        var completionResult: DataResult?
        // Act
        _ = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        // Assert
        let expectedError =  Restler.Error.request(type: .notFound, response: Restler.Response(response))
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: expectedError)
    }
    
    func testMakeRequest_responseNotNil() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        mockResponse.statusCodeReturnValue = 401
        let response = HTTPRequestResponse(data: Data(), response: mockResponse, error: TestError())
        var completionResult: DataResult?
        // Act
        _ = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        // Assert
        let expectedError = Restler.Error.request(type: .unauthorized, response: Restler.Response(response))
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: expectedError)
    }
    
    func testMakeRequest_noDataInResponse() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        let response = HTTPRequestResponse(data: nil, response: mockResponse, error: nil)
        var completionResult: DataResult?
        // Act
        _ = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        // Assert
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testMakeRequest_error() throws {
        // Arrange
        let sut = self.buildSUT()
        let returnedError = TestError()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = false
        let response = HTTPRequestResponse(data: nil, response: mockResponse, error: returnedError)
        var completionResult: DataResult?
        // Act
        _ = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        // Assert
        let expectedError = Restler.Error.request(type: .unknownError, response: Restler.Response(response))
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: expectedError)
    }
    
    func testMakeRequest_NSURLErrorCancelled() throws {
        // Arrange
        let sut = self.buildSUT()
        let returnedError = NSError(domain: "URLSession Error", code: NSURLErrorCancelled, userInfo: nil)
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let urlRequest = URLRequest(url: url)
        let response = HTTPRequestResponse(data: nil, response: nil, error: returnedError)
        var completionResult: DataResult?
        // Act
        _ = sut.makeRequest(urlRequest: urlRequest, urlSession: nil, eventLogger: eventLogger) { result in
            completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        // Assert
        let expectedError = Restler.Error.request(type: .requestCancelled, response: Restler.Response(response))
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: expectedError)
    }
}

// MARK: - buildRequest(url:method:customRequestModification:)
extension NetworkingTests {
    func testBuildRequest_get_makesProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let queryParameters = ["some": "key", "another": "key1"].map { URLQueryItem(name: $0, value: $1) }
        let header = ["key1": "value1", "key2": "value2"]
        // Act
        let request = sut.buildRequest(
            url: url,
            method: .get(query: queryParameters),
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification)
        // Assert
        let unwrappedRequest = try XCTUnwrap(request)
        let requestURL = unwrappedRequest.url
        XCTAssertTrue(try XCTUnwrap(requestURL?.query?.contains("some=key")))
        XCTAssertTrue(try XCTUnwrap(requestURL?.query?.contains("another=key1")))
        XCTAssertTrue(try XCTUnwrap(requestURL?.absoluteString.starts(with: "https://www.example.com")))
        XCTAssertEqual(unwrappedRequest.httpMethod, "GET")
        XCTAssertNil(unwrappedRequest.httpBody)
        XCTAssertEqual(unwrappedRequest.allHTTPHeaderFields, header)
        XCTAssertEqual(unwrappedRequest.cachePolicy, .reloadIgnoringCacheData)
    }
    
    func testBuildRequest_post_makesProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = Data()
        let header = ["key1": "value1", "key2": "value2"]
        // Act
        let request = sut.buildRequest(
            url: url,
            method: .post(content: content),
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification)
        // Assert
        let unwrappedRequest = try XCTUnwrap(request)
        let requestURL = try XCTUnwrap(unwrappedRequest.url)
        XCTAssertNil(requestURL.query)
        XCTAssertTrue(requestURL.absoluteString.starts(with: "https://www.example.com"))
        XCTAssertEqual(unwrappedRequest.httpMethod, "POST")
        XCTAssertEqual(unwrappedRequest.httpBody, content)
        XCTAssertEqual(unwrappedRequest.allHTTPHeaderFields, header)
        XCTAssertEqual(unwrappedRequest.cachePolicy, .reloadIgnoringCacheData)
    }
    
    func testBuildRequest_put_makesProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = Data()
        let header = ["key1": "value1", "key2": "value2"]
        // Act
        let request = sut.buildRequest(
            url: url,
            method: .put(content: content),
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification)
        // Assert
        let unwrappedRequest = try XCTUnwrap(request)
        let requestURL = try XCTUnwrap(unwrappedRequest.url)
        XCTAssertNil(requestURL.query)
        XCTAssertTrue(requestURL.absoluteString.starts(with: "https://www.example.com"))
        XCTAssertEqual(unwrappedRequest.httpMethod, "PUT")
        XCTAssertEqual(unwrappedRequest.httpBody, content)
        XCTAssertEqual(unwrappedRequest.allHTTPHeaderFields, header)
        XCTAssertEqual(unwrappedRequest.cachePolicy, .reloadIgnoringCacheData)
    }
    
    func testBuildRequest_delete_makesProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let header = ["key1": "value1", "key2": "value2"]
        // Act
        let request = sut.buildRequest(
            url: url,
            method: .delete,
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification)
        // Assert
        let unwrappedRequest = try XCTUnwrap(request)
        let requestURL = try XCTUnwrap(unwrappedRequest.url)
        XCTAssertNil(requestURL.query)
        XCTAssertTrue(requestURL.absoluteString.starts(with: "https://www.example.com"))
        XCTAssertEqual(unwrappedRequest.httpMethod, "DELETE")
        XCTAssertNil(unwrappedRequest.httpBody)
        XCTAssertEqual(unwrappedRequest.allHTTPHeaderFields, header)
        XCTAssertEqual(unwrappedRequest.cachePolicy, .reloadIgnoringCacheData)
    }
    
    func testBuildRequest_head_makesProperRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let header = ["key1": "value1", "key2": "value2"]
        // Act
        let request = sut.buildRequest(
            url: url,
            method: .head,
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification)
        // Assert
        let unwrappedRequest = try XCTUnwrap(request)
        let requestURL = try XCTUnwrap(unwrappedRequest.url)
        XCTAssertNil(requestURL.query)
        XCTAssertTrue(requestURL.absoluteString.starts(with: "https://www.example.com"))
        XCTAssertEqual(unwrappedRequest.httpMethod, "HEAD")
        XCTAssertNil(unwrappedRequest.httpBody)
        XCTAssertEqual(unwrappedRequest.allHTTPHeaderFields, header)
        XCTAssertEqual(unwrappedRequest.cachePolicy, .reloadIgnoringCacheData)
    }
}

// MARK: - Private
extension NetworkingTests {
    private func buildSUT() -> Networking {
        Networking(session: self.session)
    }
}
