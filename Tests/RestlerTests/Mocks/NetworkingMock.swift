import Foundation
@testable import Restler

class NetworkingMock {
    
    // MARK: - NetworkingType
    var headerReturnValue: [String: String] = [:]
    private(set) var headerSetParams: [HeaderSetParams] = []
    struct HeaderSetParams {
        let value: HeaderParameters
    }
    
    private(set) var makeRequestParams: [MakeRequestParams] = []
    struct MakeRequestParams {
        let url: URL
        let method: HTTPMethod
        let completion: DataCompletion
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    var header: HeaderParameters {
        get {
            self.headerReturnValue
        }
        set {
            self.headerSetParams.append(HeaderSetParams(value: newValue))
        }
    }
    
    func makeRequest(url: URL, method: HTTPMethod, completion: @escaping DataCompletion) {
        self.makeRequestParams.append(MakeRequestParams(url: url, method: method, completion: completion))
    }
}
