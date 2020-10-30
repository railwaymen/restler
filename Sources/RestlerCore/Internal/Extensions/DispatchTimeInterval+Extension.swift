import Foundation

typealias Milliseconds = Double

extension DispatchTimeInterval {
    func toMilliseconds() -> Milliseconds {
        switch self {
        case let .seconds(time):
            return Double(time) * 1_000
        case let .milliseconds(time):
            return Double(time)
        case let .microseconds(time):
            return Double(time) / 1_000
        case let .nanoseconds(time):
            return Double(time) / 1_000_000
        case .never:
            return 0
        @unknown default:
            return 0
        }
    }
}
