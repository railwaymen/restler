import Foundation
@testable import Restler

extension Restler.Error: UniqueValuedEnumerator {
    var uniqueValue: Int {
        switch self {
        case .forbiden:
            return 0
        case .internalFrameworkError:
            return 1
        case .invalidParameters:
            return 2
        case .invalidResponse:
            return 3
        case .noInternetConnection:
            return 4
        case .notFound:
            return 5
        case .serverError:
            return 6
        case .timeout:
            return 7
        case .unauthorized:
            return 8
        case .unknownError:
            return 9
        case .validationError:
            return 10
        }
    }
}
