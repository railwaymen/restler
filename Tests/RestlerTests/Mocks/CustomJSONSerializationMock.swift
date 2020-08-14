import XCTest
@testable import Restler

final class CustomJSONSerializationMock {
    
    // MARK: - JSONSerializationType
    var jsonObjectThrownError: Error?
    var jsonObjectReturnValue: Any = Int?.none as Any
    private(set) var jsonObjectParams: [JSONObjectParams] = []
    struct JSONObjectParams {
        let data: Data
        let options: JSONSerialization.ReadingOptions
    }
}

// MARK: - JSONSerializationType
extension CustomJSONSerializationMock: JSONSerializationType {
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any {
        if let error = self.jsonObjectThrownError {
            throw error
        }
        return self.jsonObjectReturnValue
    }
}
