import Foundation

extension Optional {
    func unwrap() throws -> Wrapped {
        guard let wrapped = self else { throw Restler.CommonError(type: .internalFrameworkError, base: nil) }
        return wrapped
    }
}
