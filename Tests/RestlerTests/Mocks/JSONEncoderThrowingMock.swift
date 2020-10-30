import Foundation
@testable import RestlerCore

final class JSONEncoderThrowingMock: RestlerJSONEncoderType {
    var thrownError = TestError()
    
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        throw self.thrownError
    }
}
