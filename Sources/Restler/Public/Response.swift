import Foundation

extension Restler {
    public struct Response {
        public let data: Data?
        public let response: HTTPURLResponse?
        public let error: Error?
        
        // MARK: - Initialization
        init(_ result: HTTPRequestResponse) {
            self.data = result.data
            self.response = result.response as? HTTPURLResponse
            self.error = result.error
        }
    }
}
