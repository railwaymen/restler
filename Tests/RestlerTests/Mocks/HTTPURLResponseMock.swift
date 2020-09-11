import Foundation
@testable import Restler

final class HTTPURLResponseMock {
    
    // MARK: - HTTPURLResponseType
    var isSuccessfulReturnValue: Bool = true
    
    var statusCodeReturnValue: Int = 200
    
    var allHeaderFieldsReturnValue: [AnyHashable: Any] = [:]
}

// MARK: - HTTPURLResponseType
extension HTTPURLResponseMock: HTTPURLResponseType {
    var isSuccessful: Bool {
        self.isSuccessfulReturnValue
    }
    
    var statusCode: Int {
        self.statusCodeReturnValue
    }
    
    var allHeaderFields: [AnyHashable: Any] {
        self.allHeaderFieldsReturnValue
    }
}
