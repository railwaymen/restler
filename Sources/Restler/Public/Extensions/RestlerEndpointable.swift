import Foundation

/// Protocol describing endpoint representable object.
public protocol RestlerEndpointable {
    
    /// The string value of the endpoint.
    ///
    /// It should be in format `/path/for/request`.
    /// It is appended to the base URL.
    ///
    var stringValue: String { get }
}
