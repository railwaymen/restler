import Foundation

extension Restler {
    public struct Response {
        public let data: Data?
        public let response: HTTPURLResponse?
        public let error: Swift.Error?
        
        // MARK: - Initialization
        public init(data: Data?, response: HTTPURLResponse?, error: Swift.Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        init(_ result: HTTPRequestResponse) {
            self.data = result.data
            self.response = result.response as? HTTPURLResponse
            self.error = result.error
        }
    }
}

// MARK: - Equatable
extension Restler.Response: Equatable {
    public static func == (lhs: Restler.Response, rhs: Restler.Response) -> Bool {
        return lhs.data == rhs.data
            && lhs.response == rhs.response
    }
}
