import Foundation
import Restler

struct SomeObject: Codable, Equatable, RestlerQueryEncodable {
    let id: Int
    let name: String
    let double: Double
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.double, forKey: .double)
    }
}
