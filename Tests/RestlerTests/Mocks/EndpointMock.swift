import Foundation
@testable import Restler

enum EndpointMock: RestlerEndpointable {
    case mock
    
    var stringValue: String {
        return "mock"
    }
}
