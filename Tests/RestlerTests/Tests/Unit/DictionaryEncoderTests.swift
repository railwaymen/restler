import XCTest
@testable import Restler

class DictionaryEncoderTests: XCTestCase {
    private let encoder = JSONEncoder()
    private let someObject = SomeObject(id: 1, name: "some", double: 1.23)
}

// MARK: - encode(_:)
extension DictionaryEncoderTests {
    func testEncode_encodingFailed() throws {
        //Arrange
        let sut = self.buildSUT()
        let expectedError = TestError()
        let object = ThrowingObject()
        object.thrownError = expectedError
        //Act
        //Assert
        XCTAssertThrowsError(try sut.encodeToQuery(object)) { error in
            XCTAssertEqual(error as? TestError, expectedError)
        }
    }
    
    func testEncode_parsesFullData() throws {
        //Arrange
        let sut = self.buildSUT()
        let url = try XCTUnwrap(URL(string: "https://example.com"))
        let uuid = UUID()
        let object = ComplexObject(
            id: uuid,
            currency: "USD",
            image: url,
            itemsCount: 0,
            summaryPrice: 2.56,
            multiplier: -4,
            floatValue: 92.4,
            decimalValue: 3.221,
            isAvailable: true)
        let expectedResult: [String: String?] = [
            "id": uuid.uuidString,
            "currency": "USD",
            "image": url.absoluteString,
            "itemsCount": "0",
            "summaryPrice": "2.56",
            "multiplier": "-4",
            "floatValue": "92.4",
            "decimalValue": "3.221",
            "isAvailable": "true",
        ]
        //Act
        let array = try sut.encodeToQuery(object)
        //Assert
        XCTAssertEqual(array.count, expectedResult.count)
        // TODO
//        expectedResult.forEach {
//            if let lhsString = dictionary[$0.key] as? String, let lhsValue = Double(lhsString),
//                let rhsString = $0.value, let rhsValue = Double(rhsString) {
//                XCTAssertEqual(lhsValue, rhsValue, accuracy: 0.01)
//            } else {
//                XCTAssertEqual(dictionary[$0.key], $0.value, "key: \($0.key)")
//            }
//        }
    }
}

// MARK: - Private
extension DictionaryEncoderTests {
    private func buildSUT() -> DictionaryEncoder {
        return DictionaryEncoder(encoder: Restler.QueryEncoder())
    }
}

// MARK: - Structure
private struct ComplexObject: Codable, RestlerQueryEncodable {
    let id: UUID?
    let currency: String?
    let image: URL?
    let itemsCount: UInt?
    let summaryPrice: Double?
    let multiplier: Int?
    let floatValue: Float?
    let decimalValue: Decimal?
    let isAvailable: Bool?
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.currency, forKey: .currency)
        try container.encode(self.image, forKey: .image)
        try container.encode(self.itemsCount, forKey: .itemsCount)
        try container.encode(self.summaryPrice, forKey: .summaryPrice)
        try container.encode(self.multiplier, forKey: .multiplier)
        try container.encode(self.floatValue, forKey: .floatValue)
        try container.encode(self.decimalValue, forKey: .decimalValue)
        try container.encode(self.isAvailable, forKey: .isAvailable)
    }
}
