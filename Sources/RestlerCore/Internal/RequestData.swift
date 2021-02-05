import Foundation

struct RequestData {
    let url: URL
    let method: HTTPMethod
    let content: Data?
    let query: [URLQueryItem]
    let header: Restler.Header
}
