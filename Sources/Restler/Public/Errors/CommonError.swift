import Foundation

extension Restler {
    public struct CommonError: Swift.Error {
        public let type: ErrorType
        public let base: Swift.Error?
    }
}

// MARK: - Equatable
extension Restler.CommonError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
    }
}
