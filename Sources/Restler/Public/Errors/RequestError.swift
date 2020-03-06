import Foundation

extension Restler {
    public struct RequestError: Swift.Error {
        public let type: ErrorType
        public let response: Response
    }
}

// MARK: - Equatable
extension Restler.RequestError: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.type == rhs.type
            && lhs.response == rhs.response
    }
}
