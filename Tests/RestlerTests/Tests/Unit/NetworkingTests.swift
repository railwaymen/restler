import XCTest
@testable import Restler

class NetworkingTests: XCTestCase {
    private var session: URLSessionMock!
    
    private var cacheModification: (inout URLRequest) -> Void = { request in
        request.cachePolicy = .reloadIgnoringCacheData
    }
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        self.session = URLSessionMock()
    }
}

// MARK: - makeRequest(url:method:completion:)
extension NetworkingTests {
    func testMakeRequest_get_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let queryParameters = ["some": "key", "another": "key1"].map { URLQueryItem(name: $0, value: $1) }
        let header = ["key1": "value1", "key2": "value2"]
        var completionResult: DataResult?
        //Act
        let task = sut.makeRequest(
            url: url,
            method: .get(query: queryParameters),
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification) { result in
                completionResult = result
        }
        //Assert
        XCTAssertEqual(self.session.dataTaskParams.count, 1)
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.query?.contains("some=key")))
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.query?.contains("another=key1")))
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.absoluteString.starts(with: "https://www.example.com")))
        XCTAssertEqual(self.session.dataTaskParams.last?.request.httpMethod, "GET")
        XCTAssertNil(self.session.dataTaskParams.last?.request.httpBody)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.allHTTPHeaderFields, header)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.cachePolicy, .reloadIgnoringCacheData)
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.session.dataTaskReturnValue.resumeParams.count, 1)
        XCTAssertNotNil(task)
    }
    
    func testMakeRequest_post_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = Data()
        let header = ["key1": "value1", "key2": "value2"]
        var completionResult: DataResult?
        //Act
        let task = sut.makeRequest(
            url: url,
            method: .post(content: content),
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification) { result in
                completionResult = result
        }
        //Assert
        XCTAssertEqual(self.session.dataTaskParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.session.dataTaskParams.last?.request.url).query)
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.absoluteString.starts(with: "https://www.example.com")))
        XCTAssertEqual(self.session.dataTaskParams.last?.request.httpMethod, "POST")
        XCTAssertEqual(self.session.dataTaskParams.last?.request.httpBody, content)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.allHTTPHeaderFields, header)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.cachePolicy, .reloadIgnoringCacheData)
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.session.dataTaskReturnValue.resumeParams.count, 1)
        XCTAssertNotNil(task)
    }
    
    func testMakeRequest_put_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let content = Data()
        let header = ["key1": "value1", "key2": "value2"]
        var completionResult: DataResult?
        //Act
        let task = sut.makeRequest(
            url: url,
            method: .put(content: content),
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification) { result in
                completionResult = result
        }
        //Assert
        XCTAssertEqual(self.session.dataTaskParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.session.dataTaskParams.last?.request.url).query)
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.absoluteString.starts(with: "https://www.example.com")))
        XCTAssertEqual(self.session.dataTaskParams.last?.request.httpMethod, "PUT")
        XCTAssertEqual(self.session.dataTaskParams.last?.request.httpBody, content)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.allHTTPHeaderFields, header)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.cachePolicy, .reloadIgnoringCacheData)
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.session.dataTaskReturnValue.resumeParams.count, 1)
        XCTAssertNotNil(task)
    }
    
    func testMakeRequest_delete_makesProperRequest() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let header = ["key1": "value1", "key2": "value2"]
        var completionResult: DataResult?
        //Act
        let task = sut.makeRequest(
            url: url,
            method: .delete,
            header: Restler.Header(raw: header),
            customRequestModification: self.cacheModification) { result in
                completionResult = result
        }
        //Assert
        XCTAssertEqual(self.session.dataTaskParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.session.dataTaskParams.last?.request.url).query)
        XCTAssertTrue(try XCTUnwrap(self.session.dataTaskParams.last?.request.url?.absoluteString.starts(with: "https://www.example.com")))
        XCTAssertEqual(self.session.dataTaskParams.last?.request.httpMethod, "DELETE")
        XCTAssertNil(self.session.dataTaskParams.last?.request.httpBody)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.allHTTPHeaderFields, header)
        XCTAssertEqual(self.session.dataTaskParams.last?.request.cachePolicy, .reloadIgnoringCacheData)
        XCTAssertNil(completionResult)
        XCTAssertEqual(self.session.dataTaskReturnValue.resumeParams.count, 1)
        XCTAssertNotNil(task)
    }
    
    func testMakeRequest_successfulResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        let responseData = Data()
        var completionResult: DataResult?
        //Act
        _ = sut.makeRequest(
            url: url,
            method: .get(query: []),
            header: .init(),
            customRequestModification: nil) { result in
                completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(HTTPRequestResponse(data: responseData, response: mockResponse, error: nil))
        //Assert
        XCTAssertEqual(try XCTUnwrap(completionResult).get(), responseData)
    }
    
    func testMakeRequest_noResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let response = HTTPRequestResponse(data: Data(), response: nil, error: nil)
        var completionResult: DataResult?
        //Act
        _ = sut.makeRequest(
            url: url,
            method: .get(query: []),
            header: .init(),
            customRequestModification: nil) { result in
                completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: Restler.Error.request(type: .unknownError, response: Restler.Response(response)))
    }
    
    func testMakeRequest_notFoundResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = false
        mockResponse.statusCodeReturnValue = 404
        let response = HTTPRequestResponse(data: Data(), response: mockResponse, error: nil)
        var completionResult: DataResult?
        //Act
        _ = sut.makeRequest(
            url: url,
            method: .get(query: []),
            header: .init(),
            customRequestModification: nil) { result in
                completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: Restler.Error.request(type: .notFound, response: Restler.Response(response)))
    }
    
    func testMakeRequest_responseNotNil() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        mockResponse.statusCodeReturnValue = 401
        let response = HTTPRequestResponse(data: Data(), response: mockResponse, error: TestError())
        var completionResult: DataResult?
        //Act
        _ = sut.makeRequest(
            url: url,
            method: .get(query: []),
            header: .init(),
            customRequestModification: nil) { result in
                completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: Restler.Error.request(type: .unauthorized, response: Restler.Response(response)))
    }
    
    func testMakeRequest_noDataInResponse() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = true
        var completionResult: DataResult?
        //Act
        _ = sut.makeRequest(
            url: url,
            method: .get(query: []),
            header: .init(),
            customRequestModification: nil) { result in
                completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(HTTPRequestResponse(data: nil, response: mockResponse, error: nil))
        //Assert
        XCTAssertNil(try XCTUnwrap(completionResult).get())
    }
    
    func testMakeRequest_error() throws {
        //Arrange
        let sut = self.buildSUT()
        let returnedError = TestError()
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let mockResponse = HTTPURLResponseMock()
        mockResponse.isSuccessfulReturnValue = false
        let response = HTTPRequestResponse(data: nil, response: mockResponse, error: returnedError)
        var completionResult: DataResult?
        //Act
        _ = sut.makeRequest(
            url: url,
            method: .get(query: []),
            header: .init(),
            customRequestModification: nil) { result in
                completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: Restler.Error.request(type: .unknownError, response: Restler.Response(response)))
    }
    
    func testMakeRequest_NSURLErrorCancelled() throws {
        //Arrange
        let sut = self.buildSUT()
        let returnedError = NSError(domain: "URLSession Error", code: NSURLErrorCancelled, userInfo: nil)
        let url = try XCTUnwrap(URL(string: "https://www.example.com"))
        let response = HTTPRequestResponse(data: nil, response: nil, error: returnedError)
        var completionResult: DataResult?
        //Act
        _ = sut.makeRequest(
            url: url,
            method: .get(query: []),
            header: .init(),
            customRequestModification: nil) { result in
                completionResult = result
        }
        try XCTUnwrap(self.session.dataTaskParams.last).completion(response)
        //Assert
        AssertResult(try XCTUnwrap(completionResult), errorIsEqualTo: Restler.Error.request(type: .requestCancelled, response: Restler.Response(response)))
    }
}

// MARK: - Private
extension NetworkingTests {
    private func buildSUT() -> Networking {
        return Networking(session: self.session)
    }
}
