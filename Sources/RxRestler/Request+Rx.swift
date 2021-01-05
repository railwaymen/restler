import Foundation
import RxSwift
import RestlerCore

extension Restler.Request {
    public var rx: Single<D> {
        Single<D>.create { single in
            let task = self.subscribe(
                onSuccess: { single(.success($0)) },
                onFailure: { single(.failure($0)) })
            return Disposables.create { task?.cancel() }
        }
    }
}
