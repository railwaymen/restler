import Foundation

internal protocol QueryItemsRepresentable {
    var tuples: [(key: String, value: String)] { get }
}
