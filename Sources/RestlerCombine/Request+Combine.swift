import Foundation
import RestlerCore
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension Restler.Request {
    public var publisher: RestlerRequestPublisher<D> {
        RestlerRequestPublisher<D>(request: self)
    }
}

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public struct RestlerRequestPublisher<DecodedType>: Publisher {
    public typealias Output = DecodedType
    public typealias Failure = Error
    
    private let request: Restler.Request<DecodedType>
    
    // MARK: Initialization
    public init(request: Restler.Request<DecodedType>) {
        self.request = request
    }
    
    // MARK: Publisher
    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(request: request, subscriber: subscriber)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: - Subscription
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension RestlerRequestPublisher {
    
    final class Subscription<S: Subscriber>: Combine.Subscription where Failure == S.Failure, Output == S.Input {
        var combineIdentifier: CombineIdentifier = .init()
        
        private var task: RestlerTaskType?
        private var subscriber: S?
        private let request: Restler.Request<DecodedType>
        
        // MARK: Initialization
        init(request: Restler.Request<DecodedType>, subscriber: S) {
            self.request = request
            self.subscriber = subscriber
        }
        
        // MARK: Subscription
        func request(_ demand: Subscribers.Demand) {
            task = request.subscribe(
                onSuccess: { [self] in
                    _ = subscriber?.receive($0)
                    subscriber?.receive(completion: .finished)
                },
                onFailure: { [self] in
                    subscriber?.receive(completion: .failure($0))
                })
        }
        
        func cancel() {
            subscriber = nil
            task?.cancel()
        }
    }
}
