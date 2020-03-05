import Foundation

extension Restler {
    public struct MultipleErrors: Error {
        public let errors: [Error]
    }
}
