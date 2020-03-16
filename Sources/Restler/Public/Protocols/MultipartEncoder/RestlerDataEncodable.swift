import Foundation

public protocol RestlerDataEncodable {
    func encodeToData() throws -> Data?
}
