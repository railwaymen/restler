import Foundation

extension DispatchTime {
    func since(_ time: DispatchTime) -> DispatchTimeInterval {
        .nanoseconds(Int(self.uptimeNanoseconds - time.uptimeNanoseconds))
    }
}
