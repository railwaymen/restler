import XCTest
@testable import Restler

final class RestlerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Restler().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
