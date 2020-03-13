import XCTest
@testable import Restler

class QueryEncoderIntegrationTests: XCTestCase {}

extension QueryEncoderIntegrationTests {
    func testEncoding_stringDictionary() throws {
        //Arrange
        let sut = Restler.QueryEncoder()
        //Act
        let result = try sut.encode(["value": "name"])
        //Assert
        XCTAssertEqual(result, [URLQueryItem(name: "value", value: "name")])
    }
    
    func testEncoding_intDictionary() throws {
        //Arrange
        let sut = Restler.QueryEncoder()
        //Act
        let result = try sut.encode(["value": 1])
        //Assert
        XCTAssertEqual(result, [URLQueryItem(name: "value", value: "1")])
    }
    
    func testEncoding_boolDictionary() throws {
        //Arrange
        let sut = Restler.QueryEncoder()
        //Act
        let result = try sut.encode(["value": true])
        //Assert
        XCTAssertEqual(result, [URLQueryItem(name: "value", value: "true")])
    }
    
    func testEncoding_intArrayObject() throws {
        //Arrange
        let sut = Restler.QueryEncoder()
        let object = IntArrayObject(id: 1, intArray: [1, 5, 2])
        let expectedResult = [
            URLQueryItem(name: "id", value: "1"),
            URLQueryItem(name: "intArray[]", value: "1"),
            URLQueryItem(name: "intArray[]", value: "5"),
            URLQueryItem(name: "intArray[]", value: "2"),
        ]
        //Act
        let result = try sut.encode(object)
        //Assert
        XCTAssertEqual(result, expectedResult)
    }
    
    func testEncoding_dictionaryObject() throws {
        //Arrange
        let sut = Restler.QueryEncoder()
        let object = DictionaryObject(id: 1, dictionary: ["string": 1, "another": 443])
        let expectedResult = [
            URLQueryItem(name: "id", value: "1"),
            URLQueryItem(name: "dictionary[string]", value: "1"),
            URLQueryItem(name: "dictionary[another]", value: "443"),
        ]
        //Act
        let result = try sut.encode(object)
        //Assert
        XCTAssertEqual(result.count, expectedResult.count)
        expectedResult.forEach {
            XCTAssert(result.contains($0))
        }
    }
}

// MARK: - Private structures
private struct IntArrayObject: Codable, RestlerQueryEncodable {
    let id: Int
    let intArray: [Int]
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.intArray, forKey: .intArray)
    }
}

private struct DictionaryObject: Codable, RestlerQueryEncodable {
    let id: Int
    let dictionary: [String: Int]
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.dictionary, forKey: .dictionary)
    }
}
