import Foundation

extension Restler {
    public struct RequestError: Error {
        public let type: ErrorType
        public let response: Response
    }
}

// MARK: - Equatable
extension Restler.RequestError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
    }
}
