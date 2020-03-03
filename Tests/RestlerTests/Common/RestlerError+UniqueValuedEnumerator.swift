import Foundation
@testable import Restler

extension Restler.Error: UniqueValuedEnumerator {
    var uniqueValue: Int {
        switch self {
        case .classDeinitialized:
            return 0
        case .forbiden:
            return 1
        case .internalFrameworkError:
            return 2
        case .invalidParameters:
            return 3
        case .invalidResponse:
            return 4
        case .noInternetConnection:
            return 5
        case .notFound:
            return 6
        case .serverError:
            return 7
        case .timeout:
            return 8
        case .unauthorized:
            return 9
        case .unknownError:
            return 10
        case .validationError:
            return 11
        }
    }
}
