import Foundation

enum HTTPMethod: Equatable {
    case get(query: [String: String?])
    case post(content: Data?)
    case put(content: Data?)
    case delete
    
    var name: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        }
    }
    
    var query: [String: String?]? {
        switch self {
        case let .get(query): return query
        case .post: return nil
        case .put: return nil
        case .delete: return nil
        }
    }
    
    var content: Data? {
        switch self {
        case .get: return nil
        case let .post(content): return content
        case let .put(content): return content
        case .delete: return nil
        }
    }
    
    var isQueryAvailable: Bool {
        switch self {
        case .get: return true
        case .post: return false
        case .put: return false
        case .delete: return false
        }
    }
    
    var isBodyAvailable: Bool {
        switch self {
        case .get: return false
        case .post: return true
        case .put: return true
        case .delete: return false
        }
    }
}
