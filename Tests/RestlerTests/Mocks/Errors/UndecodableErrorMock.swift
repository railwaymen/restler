import Foundation
@testable import Restler

final class UndecodableErrorMock: RestlerErrorDecodable {
    required init?(response _: Restler.Response) {
        return nil
    }
}
