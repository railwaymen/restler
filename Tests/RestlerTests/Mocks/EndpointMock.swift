import Foundation
@testable import Restler

enum EndpointMock: RestlerEndpointable {
    case mock
    
    var restlerEndpointValue: String {
        return "mock"
    }
}
