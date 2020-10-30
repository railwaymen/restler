import Foundation
@testable import RestlerCore

final class EventLoggerMock {

    // MARK: - EventLoggerConfiguration
    var levelOfDetails: Restler.LevelOfLogDetails = .concise

    // MARK: - EventLoggerLogging
    private(set) var logParams: [LogParams] = []
    struct LogParams {
        let event: Event
    }
}

// MARK: - EventLoggerConfiguration
extension EventLoggerMock: EventLoggerConfiguration {}

// MARK: - EventLoggerLogging
extension EventLoggerMock: EventLoggerLogging {
    func log(_ event: Event) {
        self.logParams.append(LogParams(event: event))
    }
}
