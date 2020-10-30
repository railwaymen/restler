import Foundation

typealias EventLoggerable = EventLoggerConfiguration & EventLoggerLogging

protocol EventLoggerConfiguration: class {
    var levelOfDetails: Restler.LevelOfLogDetails { get set }
}

protocol EventLoggerLogging: class {
    func log(_ event: Event)
}

final class EventLogger {
    var levelOfDetails: Restler.LevelOfLogDetails = .concise
}

// MARK: - EventLoggerConfiguration
extension EventLogger: EventLoggerConfiguration {}

// MARK: - EventLoggerType
extension EventLogger: EventLoggerLogging {
    func log(_ event: Event) {
        #if DEBUG
        switch levelOfDetails {
        case .nothing:
            break
        case .concise:
            print(conciseDescription(for: event))
        case .debug:
            print(detailedDescription(for: event))
        }
        #endif
    }
}

// MARK: - Private
extension EventLogger {
    private func conciseDescription(for event: Event) -> String {
        switch event {
        case let .requestCompleted(request, response, elapsedTime):
            var statusCode: String?
            if let response = response.response {
                statusCode = "\(response.statusCode)"
            }
            return """
            
            ------- REQUEST -------
            
            Method: \(request.httpMethod ?? "nil")
            URL: \(request.url?.absoluteString ?? "nil")
            Headers: \(request.allHTTPHeaderFields ?? [:])
            
            ------- RESPONSE -------
            
            Status Code: \(statusCode ?? "nil")
            Headers: \(response.response?.allHeaderFields ?? [:])
            
            Elapsed Time: \(elapsedTime) ms
            Finished: [\(Date())]
            
            """
        }
    }
    
    private func detailedDescription(for event: Event) -> String {
        switch event {
        case let .requestCompleted(request, response, elapsedTime):
            var statusCode: String?
            if let response = response.response {
                statusCode = "\(response.statusCode)"
            }
            let nilStringData: Data? = "nil".data(using: .utf8)
            return """
            
            ------- REQUEST -------
            
            Method: \(request.httpMethod ?? "nil")
            URL: \(request.url?.absoluteString ?? "nil")
            Headers: \(request.allHTTPHeaderFields ?? [:])
            Body: \(String(data: request.httpBody ?? nilStringData ?? Data(), encoding: .utf8) ?? "nil")
            
            ------- RESPONSE -------
            
            Status Code: \(statusCode ?? "nil")
            Headers: \(response.response?.allHeaderFields ?? [:])
            Body: \(String(data: response.data ?? nilStringData ?? Data(), encoding: .utf8) ?? "nil")
            
            Elapsed Time: \(elapsedTime) ms
            Finished: [\(Date())]
            
            """
        }
    }
}
