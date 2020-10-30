import Foundation
@testable import RestlerCore

final class UndecodableErrorMock: RestlerErrorDecodable {
    required init?(response _: Restler.Response) {
        return nil
    }
}
