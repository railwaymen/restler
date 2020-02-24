import Foundation
@testable import Restler

class NetworkingMock {
    
    // MARK: - NetworkingType
    private(set) var makeRequestParams: [MakeRequestParams] = []
    struct MakeRequestParams {
        let url: URL
        let method: HTTPMethod
        let completion: DataCompletion
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    func makeRequest(url: URL, method: HTTPMethod, completion: @escaping DataCompletion) {
        self.makeRequestParams.append(MakeRequestParams(url: url, method: method, completion: completion))
    }
}
