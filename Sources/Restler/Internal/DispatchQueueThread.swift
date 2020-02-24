import Foundation

enum DispatchQueueThread: Equatable {
    case main
    case background(qos: DispatchQoS.QoSClass)
    
    var queue: DispatchQueue {
        switch self {
        case .main: return DispatchQueue.main
        case let .background(qos): return DispatchQueue.global(qos: qos)
        }
    }
}
