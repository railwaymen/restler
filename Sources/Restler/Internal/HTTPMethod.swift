import Foundation

enum HTTPMethod: Equatable {
    case get(query: [String: String?])
    
    var name: String {
        switch self {
        case .get: return "GET"
        }
    }
    
    var query: [String: String?]? {
        switch self {
        case let .get(query): return query
        }
    }
}
