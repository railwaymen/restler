import Foundation
@testable import Restler

class DispatchQueueManagerMock {
    
    // MARK: - DispatchQueueManagerType
    private(set) var performParams: [PerformParams] = []
    struct PerformParams {
        let thread: DispatchQueueThread
        let syncType: DispatchQueueSynchronizationType
        let action: () -> Void
    }
}

// MARK: - DispatchQueueManagerType
extension DispatchQueueManagerMock: DispatchQueueManagerType {
    func perform(on thread: DispatchQueueThread, _ syncType: DispatchQueueSynchronizationType, action: @escaping () -> Void) {
        self.performParams.append(PerformParams(thread: thread, syncType: syncType, action: action))
    }
}
