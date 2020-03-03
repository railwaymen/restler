import Foundation

enum HTTPMethod: Equatable {
    case get(query: [String: String?])
    case post(content: Data?)
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
    
    var query: [String: String?]? {
        switch self {
        case let .get(query): return query
        case .post: return nil
        }
    }
    
    var content: Data? {
        switch self {
        case let .post(content): return content
        case .get: return nil
        }
    }
}
