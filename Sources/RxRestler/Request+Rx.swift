import Foundation
import RxSwift
import Restler

extension Restler.Request {
    // swiftlint:disable:next identifier_name
    public var rx: Single<D> {
        Single<D>.create { single in
            let task = self.subscribe(
                onSuccess: { single(.success($0)) },
                onFailure: { single(.error($0)) })
            return Disposables.create { task?.cancel() }
        }
    }
}
