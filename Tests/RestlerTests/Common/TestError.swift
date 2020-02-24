import Foundation

class TestError: Error {}

// MARK: - Equatable
extension TestError: Equatable {
    static func == (lhs: TestError, rhs: TestError) -> Bool {
        return lhs === rhs
    }
}
