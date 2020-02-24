import Foundation

extension Restler {
    public enum Error: Swift.Error {
        case forbiden
        case internalFrameworkError
        case invalidParameters
        case invalidResponse
        case noInternetConnection
        case notFound
        case serverError
        case timeout
        case unauthorized
        case unknownError
        case validationError
        
        // MARK: - Initialization
        init(statusCode: Int) {
            switch statusCode {
            case 15: self = .noInternetConnection
            case 23: self = .timeout
            case 401: self = .unauthorized
            case 403: self = .forbiden
            case 404: self = .notFound
            case 422: self = .validationError
            case 500: self = .serverError
            case NSURLErrorBadServerResponse: self = .invalidResponse
            case NSURLErrorBadURL: self = .invalidParameters
            case NSURLErrorNetworkConnectionLost: self = .noInternetConnection
            case NSURLErrorTimedOut: self = .timeout
            case NSURLErrorUnknown: self = .unknownError
            default: self = .unknownError
            }
        }
    }
}
