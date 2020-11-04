import Foundation
import RestlerCore

final class ThrowingObject: Codable, RestlerQueryEncodable, RestlerMultipartEncodable {
    var thrownError: Error = TestError()
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        throw self.thrownError
    }
    
    func encode(to encoder: Encoder) throws {
        throw self.thrownError
    }
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        throw self.thrownError
    }
    
    func encodeToMultipart(encoder: RestlerMultipartEncoderType) throws {
        throw self.thrownError
    }
}
