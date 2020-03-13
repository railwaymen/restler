import Foundation

/// A protocol for the decodable error for Restler framework.
public protocol RestlerErrorDecodable: Error {
    
    /// The initializer for the error.
    ///
    /// Returning nil in this initializer means to the Restler framework, that decoding has failed.
    /// So the error won't be decoded if the init returns nil.
    ///
    /// - Parameters:
    ///   - response: Response of the failed request.
    ///
    init?(response: Restler.Response)
}
