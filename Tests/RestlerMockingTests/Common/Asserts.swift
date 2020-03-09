import XCTest

func XCTUnwrap<T>(_ optional: @autoclosure () -> T?, file: StaticString = #file, line: UInt = #line) throws -> T {
    guard let unwrapped = optional() else {
        let error = "XCTUnwrap: expected non-nil value"
        XCTFail(error, file: file, line: line)
        throw error
    }
    return unwrapped
}
