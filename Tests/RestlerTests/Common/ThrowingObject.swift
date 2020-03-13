import Foundation
import Restler

class ThrowingObject: Codable, RestlerQueryEncodable {
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
}
