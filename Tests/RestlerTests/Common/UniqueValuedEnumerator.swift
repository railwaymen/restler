import Foundation
@testable import RestlerCore

protocol UniqueValuedEnumerator {
    var uniqueValue: Int { get }
}

extension Restler.Error: UniqueValuedEnumerator {
    var uniqueValue: Int {
        switch self {
        case .common: return 0
        case .multiple: return 1
        case .request: return 2
        }
    }
}
