import Foundation
@testable import RestlerCore

enum EndpointMock: RestlerEndpointable {
    case mock
    
    var restlerEndpointValue: String { "mock" }
}
