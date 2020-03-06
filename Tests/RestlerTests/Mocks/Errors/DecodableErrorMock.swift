import Foundation
@testable import Restler

class DecodableErrorMock: RestlerErrorDecodable {
    required init?(response _: Restler.Response) {}
}
    
