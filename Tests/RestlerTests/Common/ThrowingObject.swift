import Foundation

class ThrowingObject: Codable {
    var thrownError: Error = TestError()
    
    init() {}
    
    required init(from decoder: Decoder) throws {
        throw self.thrownError
    }
    
    func encode(to encoder: Encoder) throws {
        throw self.thrownError
    }
}
