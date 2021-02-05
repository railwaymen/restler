import Foundation

enum HTTPMethod: Equatable {
    case get
    case post
    case put
    case patch
    case delete
    case head
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        case .head: return "HEAD"
        }
    }
}
