import Foundation
@testable import Restler

class UndecodableErrorMock: RestlerErrorDecodable {
    required init?(response _: Restler.Response) {
        return nil
    }
}
