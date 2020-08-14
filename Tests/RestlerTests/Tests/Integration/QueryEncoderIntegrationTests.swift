import XCTest
@testable import Restler

final class QueryEncoderIntegrationTests: XCTestCase {}

extension QueryEncoderIntegrationTests {
    func testEncoding_stringDictionary() throws {
        //Arrange
        let sut = Restler.QueryEncoder(jsonEncoder: JSONEncoder())
        //Act
        let result = try sut.encode(["value": "name"])
        //Assert
        XCTAssertEqual(result, [URLQueryItem(name: "value", value: "name")])
    }
    
    func testEncoding_intDictionary() throws {
        //Arrange
        let sut = Restler.QueryEncoder(jsonEncoder: JSONEncoder())
        //Act
        let result = try sut.encode(["value": 1])
        //Assert
        XCTAssertEqual(result, [URLQueryItem(name: "value", value: "1")])
    }
    
    func testEncoding_boolDictionary() throws {
        //Arrange
        let sut = Restler.QueryEncoder(jsonEncoder: JSONEncoder())
        //Act
        let result = try sut.encode(["value": true])
        //Assert
        XCTAssertEqual(result, [URLQueryItem(name: "value", value: "true")])
    }
    
    func testEncoding_intArrayObject() throws {
        //Arrange
        let sut = Restler.QueryEncoder(jsonEncoder: JSONEncoder())
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
        let sut = Restler.QueryEncoder(jsonEncoder: JSONEncoder())
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
    
    func testEncoding_dateObject_iso8601Format() throws {
        //Arrange
        let encoder = JSONEncoder()
        if #available(OSX 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) {
            encoder.dateEncodingStrategy = .iso8601
        } else {
            try XCTSkipIf(true, "Test on newer OS!")
        }
        let sut = Restler.QueryEncoder(jsonEncoder: encoder)
        let date = try self.buildDate(year: 2019, month: 02, day: 27, hour: 18, minute: 07, second: 34)
        let expectedDate = "2019-02-27T18:07:34Z"
        let object = DateObject(id: 3, date: date)
        let expectedResult = [
            URLQueryItem(name: "id", value: "3"),
            URLQueryItem(name: "date", value: expectedDate)
        ]
        //Act
        let result = try sut.encode(object)
        //Assert
        XCTAssertEqual(result, expectedResult)
    }
    
    func testEncoding_dateObject_secondsFormat() throws {
        //Arrange
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        let sut = Restler.QueryEncoder(jsonEncoder: encoder)
        let date = try self.buildDate(year: 2019, month: 02, day: 27, hour: 18, minute: 07, second: 34)
        let expectedDate = "\(Int(date.timeIntervalSince1970))"
        let object = DateObject(id: 3, date: date)
        let expectedResult = [
            URLQueryItem(name: "id", value: "3"),
            URLQueryItem(name: "date", value: expectedDate)
        ]
        //Act
        let result = try sut.encode(object)
        //Assert
        XCTAssertEqual(result, expectedResult)
    }
}

// MARK: - Private
extension QueryEncoderIntegrationTests {
    // swiftlint:disable:next function_parameter_count
    private func buildDate(
        year: Int,
        month: Int,
        day: Int,
        hour: Int,
        minute: Int,
        second: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Date {
        let components = DateComponents(
            calendar: .init(identifier: .iso8601),
            timeZone: TimeZone(secondsFromGMT: 0),
            year: year,
            month: month,
            day: day,
            hour: hour,
            minute: minute,
            second: second)
        return try XCTUnwrap(components.date, file: file, line: line)
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

private struct DateObject: Codable, RestlerQueryEncodable {
    let id: Int
    let date: Date
    
    func encodeToQuery(using encoder: RestlerQueryEncoderType) throws {
        let container = encoder.container(using: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.date, forKey: .date)
    }
}
