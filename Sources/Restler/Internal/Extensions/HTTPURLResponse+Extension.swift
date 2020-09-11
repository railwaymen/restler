import Foundation

protocol HTTPURLResponseType: class {
    var isSuccessful: Bool { get }
    var statusCode: Int { get }
    var allHeaderFields: [AnyHashable: Any] { get }
}

extension HTTPURLResponse: HTTPURLResponseType {
    var isSuccessful: Bool {
        return 200...299 ~= self.statusCode
    }
}
