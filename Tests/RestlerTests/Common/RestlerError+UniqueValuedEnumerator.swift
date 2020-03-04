import XCTest
@testable import Restler

extension Restler.Error: UniqueValuedEnumerator {
    var uniqueValue: Int {
        let allCases: [Restler.Error] = [
            .forbidden,
            .internalFrameworkError,
            .invalidParameters,
            .invalidResponse,
            .invalidURL,
            .noInternetConnection,
            .notFound,
            .serverError,
            .timeout,
            .unauthorized,
            .unknownError,
            .validationError(nil)
        ]
        guard let value = allCases.firstIndex(of: self) else {
            XCTFail("Case not found in all cases array.")
            return -1
        }
        return value
    }
}
