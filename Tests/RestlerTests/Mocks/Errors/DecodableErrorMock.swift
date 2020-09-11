import Foundation
@testable import Restler

final class DecodableErrorMock: RestlerErrorDecodable {
    required init?(response _: Restler.Response) {}
}
    
