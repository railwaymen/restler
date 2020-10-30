import Foundation
@testable import RestlerCore

final class DecodableErrorMock: RestlerErrorDecodable {
    required init?(response _: Restler.Response) {}
}
    
