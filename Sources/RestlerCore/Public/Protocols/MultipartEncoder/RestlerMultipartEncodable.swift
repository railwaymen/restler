import Foundation

public protocol RestlerMultipartEncodable {
    func encodeToMultipart(encoder: RestlerMultipartEncoderType) throws
}
