import Foundation

extension Restler {
    public typealias DecodableResult<T: Decodable> = Result<T, Swift.Error>
    public typealias DecodableCompletion<T: Decodable> = (DecodableResult<T>) -> Void
    
    public typealias VoidResult = Result<Void, Swift.Error>
    public typealias VoidCompletion = (VoidResult) -> Void
}
