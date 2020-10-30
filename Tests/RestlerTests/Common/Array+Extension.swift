import Foundation
import RestlerCore

extension Array where Element == (String, RestlerStringEncodable) {
    func toQueryItems() -> [URLQueryItem] {
        self.map { URLQueryItem(name: $0, value: $1.restlerStringValue) }
    }
}
