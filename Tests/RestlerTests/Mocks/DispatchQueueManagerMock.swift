import Foundation
@testable import RestlerCore

final class DispatchQueueManagerMock {
    
    // MARK: - DispatchQueueManagerType
    private(set) var asyncParams: [AsyncParams] = []
    struct AsyncParams {
        let queue: DispatchQueue?
        let action: () -> Void
    }
}

// MARK: - DispatchQueueManagerType
extension DispatchQueueManagerMock: DispatchQueueManagerType {
    func async(on queue: DispatchQueue?, execute action: @escaping @convention(block) () -> Void) {
        self.asyncParams.append(AsyncParams(queue: queue, action: action))
        action()
    }
}
