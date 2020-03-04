import Foundation

extension Restler {
    public enum Error: Swift.Error, CustomDebugStringConvertible {
        private static let prefix = "[Restler]"
        
        case forbidden
        case internalFrameworkError
        case invalidParameters
        case invalidResponse
        case invalidURL
        case noInternetConnection
        case notFound
        case serverError
        case timeout
        case unauthorized
        case unknownError
        case validationError(Swift.Error?)
        
        // MARK: - Getters
        public var debugDescription: String {
            switch self {
            case .forbidden: return "\(Error.prefix) The request is has been forbidden. You have no access to the accessed."
            case .internalFrameworkError: return "\(Error.prefix) Some unexpected error in the framework have occured. Please let know to the creators about the case."
            case .invalidParameters: return "\(Error.prefix) Parameters cannot be parsed."
            case .invalidResponse: return "\(Error.prefix) Response cannot be parsed to the expected type."
            case .invalidURL: return "\(Error.prefix) Provided URL is invalid."
            case .noInternetConnection: return "\(Error.prefix) There's no connection to the internet."
            case .notFound: return "\(Error.prefix) Not found."
            case .serverError: return "\(Error.prefix) Server internal error - 500."
            case .timeout: return "\(Error.prefix) The request has been timed out."
            case .unauthorized: return "\(Error.prefix) Unauthorized - authorization is needed for this request."
            case .unknownError: return "\(Error.prefix) Unknown error occured. Probably response is not successful, but no error is provided."
            case .validationError(let error): return "\(Error.prefix) Request validation error: \((error as NSError?)?.debugDescription ?? "nil")."
            }
        }
        
        // MARK: - Initialization
        init?(result: HTTPRequestResponse) {
            guard let response = result.response else { return nil }
            switch response.statusCode {
            case 15: self = .noInternetConnection
            case 23: self = .timeout
            case 401: self = .unauthorized
            case 403: self = .forbidden
            case 404: self = .notFound
            case 422: self = .validationError(result.error)
            case 500: self = .serverError
            case NSURLErrorBadServerResponse: self = .invalidResponse
            case NSURLErrorBadURL: self = .invalidURL
            case NSURLErrorNetworkConnectionLost: self = .noInternetConnection
            case NSURLErrorTimedOut: self = .timeout
            case NSURLErrorUnknown: self = .unknownError
            default: return nil
            }
        }
    }
}

// MARK: - Equatable
extension Restler.Error: Equatable {
    public static func == (lhs: Restler.Error, rhs: Restler.Error) -> Bool {
        switch (lhs, rhs) {
        case (.forbidden, .forbidden): return true
        case (.internalFrameworkError, .internalFrameworkError): return true
        case (.invalidParameters, .invalidParameters): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.invalidURL, .invalidURL): return true
        case (.noInternetConnection, .noInternetConnection): return true
        case (.notFound, .notFound): return true
        case (.serverError, .serverError): return true
        case (.timeout, .timeout): return true
        case (.unauthorized, .unauthorized): return true
        case (.unknownError, .unknownError): return true
        case (.validationError, .validationError): return true
        default: return false
        }
    }
}
