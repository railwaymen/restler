import Foundation

extension Dictionary {
    func existsValue(forKey key: Key) -> Bool {
        return self[key] == nil
            || self[key] as? NSNull == nil
    }
}
