import Foundation
@testable import Restler

class NetworkingMock {
    
    // MARK: - NetworkingType
    private(set) var getParams: [GetParams] = []
    struct GetParams {
        let url: URL
        let query: [String : String?]
        let completion: DataCompletion
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    func get(url: URL, query: [String : String?], completion: @escaping DataCompletion) {
        self.getParams.append(GetParams(url: url, query: query, completion: completion))
    }
}
