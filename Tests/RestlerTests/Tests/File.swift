import XCTest
@testable import Restler

class TaskTests: XCTestCase {
    private var task: URLSessionDataTaskMock!
    
    override func setUp() {
        super.setUp()
        self.task = URLSessionDataTaskMock()
    }
}

// MARK: - identifier
extension TaskTests {
    func testIdentifier() {
        //Arrange
        let sut = Restler.Task(task: self.task)
        let expectedID = 1121
        self.task.taskIdentifierReturnValue = expectedID
        //Act
        let id = sut.identifier
        //Assert
        XCTAssertEqual(id, expectedID)
    }
}

// MARK: - cancel()
extension TaskTests {
    func testCancel() {
        //Arrange
        let sut = Restler.Task(task: self.task)
        //Act
        sut.cancel()
        //Assert
        XCTAssertEqual(self.task.cancelParams.count, 1)
    }
}

// MARK: - suspend()
extension TaskTests {
    func testSuspend() {
        //Arrange
        let sut = Restler.Task(task: self.task)
        //Act
        sut.suspend()
        //Assert
        XCTAssertEqual(self.task.suspendParams.count, 1)
    }
}

// MARK: - resume()
extension TaskTests {
    func testResume() {
        //Arrange
        let sut = Restler.Task(task: self.task)
        //Act
        sut.resume()
        //Assert
        XCTAssertEqual(self.task.resumeParams.count, 1)
    }
}
