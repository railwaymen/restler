import Foundation

extension Date {
    func toString(using encoder: RestlerJSONEncoderType) throws -> String {
        let data = try encoder.encode([self])
        var finalString: String?
        let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
        if let numberArray = jsonObject as? [NSNumber] {
            finalString = numberArray[0].stringValue
        } else if let stringArray = jsonObject as? [String] {
            finalString = stringArray[0]
        }
        guard let string = finalString else { throw Restler.internalError() }
        return string
    }
}
