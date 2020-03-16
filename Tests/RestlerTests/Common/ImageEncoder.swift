import Foundation
import Restler

struct ImageEncoder: Encodable, RestlerMultipartEncodable {
    let id: Int
    let title: String
    let image: Restler.MultipartObject
    
    func encodeToMultipart(encoder: RestlerMultipartEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.title, forKey: .title)
        try container.encode(self.image, forKey: .image)
    }
}
