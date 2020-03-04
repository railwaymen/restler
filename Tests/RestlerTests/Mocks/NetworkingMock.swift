import Foundation
@testable import Restler

class NetworkingMock {
    
    // MARK: - NetworkingType
    var headerReturnValue: Restler.Header = .init()
    private(set) var headerSetParams: [HeaderSetParams] = []
    struct HeaderSetParams {
        let value: Restler.Header
    }
    
    var makeRequestReturnValue: Restler.Task?
    private(set) var makeRequestParams: [MakeRequestParams] = []
    struct MakeRequestParams {
        let url: URL
        let method: HTTPMethod
        let completion: DataCompletion
    }
}

// MARK: - NetworkingType
extension NetworkingMock: NetworkingType {
    var header: Restler.Header {
        get {
            self.headerReturnValue
        }
        set {
            self.headerSetParams.append(HeaderSetParams(value: newValue))
        }
    }
    
    func makeRequest(url: URL, method: HTTPMethod, completion: @escaping DataCompletion) -> Restler.Task? {
        self.makeRequestParams.append(MakeRequestParams(url: url, method: method, completion: completion))
        return self.makeRequestReturnValue
    }
}
