import Foundation
@testable import Restler

final class HTTPURLResponseMock {
    
    // MARK: - HTTPURLResponseType
    var isSuccessfulReturnValue: Bool = true
    
    var statusCodeReturnValue: Int = 200
}

// MARK: - HTTPURLResponseType
extension HTTPURLResponseMock: HTTPURLResponseType {
    var isSuccessful: Bool {
        self.isSuccessfulReturnValue
    }
    
    var statusCode: Int {
        self.statusCodeReturnValue
    }
}
