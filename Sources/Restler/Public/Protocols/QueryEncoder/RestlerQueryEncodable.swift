import Foundation

public protocol RestlerQueryEncodable {
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws
}
