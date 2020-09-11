import Foundation

extension Restler {
    public enum Error: Swift.Error {
        case common(type: ErrorType, base: Swift.Error)
        case request(type: ErrorType, response: Response)
        indirect case multiple([Error])
    }
}

// MARK: - Equatable
extension Restler.Error: Equatable {
    public static func == (lhs: Restler.Error, rhs: Restler.Error) -> Bool {
        switch (lhs, rhs) {
        case let (.common(lhsType, _), .common(rhsType, _)):
            return lhsType == rhsType
            
        case let (.request(lhsType, lhsResponse), .request(rhsType, rhsResponse)):
            return lhsType == rhsType && lhsResponse == rhsResponse
            
        case let (.multiple(lhsErrors), .multiple(rhsErrors)):
            return lhsErrors == rhsErrors
            
        default:
            return false
        }
    }
}

// MARK: - Array Extension
extension Array where Element == Restler.Error {
    func single() -> Restler.Error? {
        guard let first = self.first else { return nil }
        guard self.count == 1 else { return .multiple(self) }
        return first
    }
}
