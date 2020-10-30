import Foundation

// swiftlint:disable cyclomatic_complexity
extension Restler {
    public enum ErrorType: CustomDebugStringConvertible, Equatable {
        private static let prefix = "[Restler]"
        
        case forbidden
        case internalFrameworkError
        case invalidParameters
        case invalidResponse
        case invalidURL
        case noInternetConnection
        case notFound
        case requestCancelled
        case serverError
        case timeout
        case unauthorized
        case unknownError
        case validationError
        
        // MARK: - Getters
        public var debugDescription: String {
            switch self {
            case .forbidden:
                return "\(Self.prefix) The request is has been forbidden. You have no access to the accessed."
            case .internalFrameworkError:
                return "\(Self.prefix) Some unexpected error in the framework have occured. "
                + "Please let know to the creators about the case."
            case .invalidParameters:
                return "\(Self.prefix) Parameters cannot be parsed."
            case .invalidResponse:
                return "\(Self.prefix) Response cannot be parsed to the expected type."
            case .invalidURL:
                return "\(Self.prefix) Provided URL is invalid."
            case .noInternetConnection:
                return "\(Self.prefix) There's no connection to the internet."
            case .notFound:
                return "\(Self.prefix) Not found."
            case .requestCancelled:
                return "\(Self.prefix) Request has been cancelled."
            case .serverError:
                return "\(Self.prefix) Server internal error - 500."
            case .timeout:
                return "\(Self.prefix) The request has been timed out."
            case .unauthorized:
                return "\(Self.prefix) Unauthorized - authorization is needed for this request."
            case .unknownError:
                return "\(Self.prefix) Unknown error occured. Probably response is not successful, but no error is provided."
            case .validationError:
                return "\(Self.prefix) Request validation error."
            }
        }
        
        // MARK: - Initialization
        init?(statusCode: Int) {
            switch statusCode {
            case 15: self = .noInternetConnection
            case 23: self = .timeout
            case 401: self = .unauthorized
            case 403: self = .forbidden
            case 404: self = .notFound
            case 422: self = .validationError
            case 500: self = .serverError
            case NSURLErrorBadServerResponse: self = .invalidResponse
            case NSURLErrorBadURL: self = .invalidURL
            case NSURLErrorNetworkConnectionLost: self = .noInternetConnection
            case NSURLErrorTimedOut: self = .timeout
            case NSURLErrorUnknown: self = .unknownError
            case NSURLErrorCancelled: self = .requestCancelled
            default: return nil
            }
        }
    }
}
// swiftlint:enable cyclomatic_complexity
