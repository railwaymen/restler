import Foundation

enum HTTPMethod: Equatable {
    case get(query: [URLQueryItem])
    case post(content: Data?)
    case put(content: Data?)
    case patch(content: Data?)
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
    
    var query: [URLQueryItem]? {
        switch self {
        case let .get(query): return query
        case .post: return nil
        case .put: return nil
        case .patch: return nil
        case .delete: return nil
        case .head: return nil
        }
    }
    
    var content: Data? {
        switch self {
        case .get: return nil
        case let .post(content): return content
        case let .put(content): return content
        case let .patch(content): return content
        case .delete: return nil
        case .head: return nil
        }
    }
    
    var isQueryAvailable: Bool {
        switch self {
        case .get: return true
        case .post: return false
        case .put: return false
        case .patch: return false
        case .delete: return false
        case .head: return false
        }
    }
    
    var isBodyAvailable: Bool {
        switch self {
        case .get: return false
        case .post: return true
        case .put: return true
        case .patch: return true
        case .delete: return false
        case .head: return false
        }
    }
    
    var isMultipartAvailable: Bool {
        switch self {
        case .get: return false
        case .post: return true
        case .put: return false
        case .patch: return false
        case .delete: return false
        case .head: return false
        }
    }
    
    func combinedWith(query: [URLQueryItem]?, body: Data?) -> HTTPMethod {
        switch self {
        case .get:
            return .get(query: query ?? [])
        case .post:
            return .post(content: body)
        case .put:
            return .put(content: body)
        case .patch:
            return .patch(content: body)
        case .delete:
            return .delete
        case .head:
            return .head
        }
    }
}
