import Foundation
@testable import Restler

class NetworkingMock {
    
    // MARK: - NetworkingType
    var makeRequestReturnValue: Restler.Task?
    private(set) var makeRequestParams: [MakeRequestParams] = []
    struct MakeRequestParams {
        let url: URL
        let method: HTTPMethod
        let header: Restler.Header
        let customRequestModification: ((inout URLRequest) -> Void)?
        let completion: DataCompletion
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    func makeRequest(
        url: URL,
        method: HTTPMethod,
        header: Restler.Header,
        customRequestModification: ((inout URLRequest) -> Void)?,
        completion: @escaping DataCompletion
    ) -> Restler.Task? {
        self.makeRequestParams.append(MakeRequestParams(
            url: url,
            method: method,
            header: header,
            customRequestModification: customRequestModification,
            completion: completion))
        return self.makeRequestReturnValue
    }
}
