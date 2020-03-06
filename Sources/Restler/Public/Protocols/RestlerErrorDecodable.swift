import Foundation

public protocol RestlerErrorDecodable: Error {
    init?(response: Restler.Response)
}
