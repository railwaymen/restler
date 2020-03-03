import Foundation

public typealias DecodableResult<T: Decodable> = Result<T, Error>
public typealias DecodableCompletion<T: Decodable> = (DecodableResult<T>) -> Void

public typealias VoidResult = Result<Void, Error>
public typealias VoidCompletion = (VoidResult) -> Void
