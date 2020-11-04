import Foundation

protocol JSONSerializationType: class {
    func jsonObject(with data: Data, options opt: JSONSerialization.ReadingOptions) throws -> Any
}

final class CustomJSONSerialization: JSONSerializationType {
    func jsonObject(with data: Data, options: JSONSerialization.ReadingOptions) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: options)
    }
}
