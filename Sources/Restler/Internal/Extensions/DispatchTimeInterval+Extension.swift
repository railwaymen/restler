import Foundation

typealias Milliseconds = Int

extension DispatchTimeInterval {
    func toMilliseconds() -> Milliseconds {
        switch self {
        case let .seconds(time):
            return time * 1000
        case let .milliseconds(time):
            return time
        case let .microseconds(time):
            return Int((Double(time) / 1000).rounded())
        case let .nanoseconds(time):
            return Int((Double(time) / 1_000_000).rounded())
        case .never:
            return 0
        @unknown default:
            return -1
        }
    }
}
