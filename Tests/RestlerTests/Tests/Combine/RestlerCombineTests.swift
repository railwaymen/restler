import XCTest
import Combine
@testable import RestlerCore
@testable import RestlerCombine

final class RestlerCombineTests: InterfaceIntegrationTestsBase {
    private var subscribtions: Set<AnyCancellable> = []
}

extension RestlerCombineTests {
    func testGetVoid_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var valueReceivedCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { valueReceivedCount += 1 })
            .store(in: &subscribtions)
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.networking.makeRequestParams.last).urlSession)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
        XCTAssertEqual(valueReceivedCount, 0)
    }
    
    func testGetVoid_withCustomSession_buildsRequest() throws {
        // Arrange
        let sut = self.buildSUT()
        let session = URLSession(configuration: .default)
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var valueReceivedCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .using(session: session)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { valueReceivedCount += 1 })
            .store(in: &subscribtions)
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.networking.makeRequestParams.last?.urlSession as? URLSession, session)
        XCTAssertEqual(self.networking.buildRequestParams.count, 1)
        XCTAssertNil(completionResult)
        XCTAssertEqual(valueReceivedCount, 0)
    }
    
    func testGetVoid_success() throws {
        // Arrange
        let sut = self.buildSUT()
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var valueReceivedCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .decode(Void.self)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { valueReceivedCount += 1 })
            .store(in: &subscribtions)
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(nil))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(valueReceivedCount, 1)
        guard case .finished = completionResult else { return XCTFail() }
    }
    
    func testGetVoid_failure_undecodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var valueReceivedCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .failureDecode(UndecodableErrorMock.self)
            .decode(Void.self)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { valueReceivedCount += 1 })
            .store(in: &subscribtions)
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(valueReceivedCount, 0)
        guard case let .failure(returnedError) = completionResult else { return XCTFail() }
        XCTAssertEqual(returnedError as? Restler.Error, error)
    }
    
    func testGetVoid_failure_decodableError() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var valueReceivedCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .decode(Void.self)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { valueReceivedCount += 1 })
            .store(in: &subscribtions)
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(valueReceivedCount, 0)
        guard case let .failure(returnedError) = completionResult else { return XCTFail() }
        XCTAssert(returnedError is DecodableErrorMock)
    }
    
    func testGetVoid_failure_multipleErrors() throws {
        // Arrange
        let sut = self.buildSUT()
        let response = Restler.Response(.init(data: nil, response: nil, error: nil))
        let error = Restler.Error.request(type: .validationError, response: response)
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var valueReceivedCount: Int = 0
        // Act
        sut.get(self.endpoint)
            .failureDecode(DecodableErrorMock.self)
            .failureDecode(UndecodableErrorMock.self)
            .failureDecode(DecodableErrorMock.self)
            .decode(Void.self)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { valueReceivedCount += 1 })
            .store(in: &subscribtions)
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.failure(error))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(valueReceivedCount, 0)
        guard case let .failure(returnedError) = completionResult else { return XCTFail() }
        guard case let .multiple(errors) = returnedError as? Restler.Error else { return XCTFail() }
        XCTAssertEqual(errors.count, 2)
        
        guard case let .common(firstType, firstBase) = errors.first else { return XCTFail() }
        XCTAssertEqual(firstType, .unknownError)
        XCTAssert(firstBase is DecodableErrorMock)
        
        guard case let .common(secondType, secondBase) = errors.last else { return XCTFail() }
        XCTAssertEqual(secondType, .unknownError)
        XCTAssert(secondBase is DecodableErrorMock)
    }
    
    func testGetOptionalDecodable_success() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var decodedObject: SomeObject?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject?.self)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { decodedObject = $0 })
            .store(in: &subscribtions)
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(decodedObject, expectedObject)
        guard case .finished = completionResult else { return XCTFail() }
    }
    
    func testGetDecodable_success() throws {
        // Arrange
        let sut = self.buildSUT()
        let expectedObject = SomeObject(id: 1, name: "some", double: 1.23)
        let data = try JSONEncoder().encode(expectedObject)
        var completionResult: Subscribers.Completion<RestlerRequestPublisher<Void>.Failure>?
        var decodedObject: SomeObject?
        // Act
        sut.get(self.endpoint)
            .decode(SomeObject.self)
            .publisher
            .sink(
                receiveCompletion: { completion in completionResult = completion },
                receiveValue: { decodedObject = $0 })
            .store(in: &subscribtions)
        try XCTUnwrap(self.networking.makeRequestParams.first).completion(.success(data))
        // Assert
        XCTAssertEqual(self.networking.makeRequestParams.count, 1)
        XCTAssertEqual(self.dispatchQueueManager.asyncParams.count, 1)
        XCTAssertNil(try XCTUnwrap(self.dispatchQueueManager.asyncParams.last).queue)
        XCTAssertEqual(decodedObject, expectedObject)
        guard case .finished = completionResult else { return XCTFail() }
    }
}
