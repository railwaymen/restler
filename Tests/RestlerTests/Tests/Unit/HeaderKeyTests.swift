import XCTest
@testable import Restler

final class HeaderKeyTests: XCTestCase {}

// MARK: - rawValue
extension HeaderKeyTests {
    func testRawValue_a_im() {
        //Arrange
        let sut: Restler.Header.Key = .a_im
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "A-IM")
    }
    
    func testRawValue_accept() {
        //Arrange
        let sut: Restler.Header.Key = .accept
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Accept")
    }
    
    func testRawValue_acceptCharset() {
        //Arrange
        let sut: Restler.Header.Key = .acceptCharset
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Accept-Charset")
    }
    
    func testRawValue_acceptDatetime() {
        //Arrange
        let sut: Restler.Header.Key = .acceptDatetime
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Accept-Datetime")
    }
    
    func testRawValue_acceptEncoding() {
        //Arrange
        let sut: Restler.Header.Key = .acceptEncoding
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Accept-Encoding")
    }
    
    func testRawValue_acceptLanguage() {
        //Arrange
        let sut: Restler.Header.Key = .acceptLanguage
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Accept-Language")
    }
    
    func testRawValue_accessControlRequestMethod() {
        //Arrange
        let sut: Restler.Header.Key = .accessControlRequestMethod
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Access-Control-Request-Method")
    }
    
    func testRawValue_accessControlRequestHeaders() {
        //Arrange
        let sut: Restler.Header.Key = .accessControlRequestHeaders
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Access-Control-Request-Headers")
    }
    
    func testRawValue_authorization() {
        //Arrange
        let sut: Restler.Header.Key = .authorization
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Authorization")
    }
    
    func testRawValue_cacheControl() {
        //Arrange
        let sut: Restler.Header.Key = .cacheControl
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Cache-Control")
    }
    
    func testRawValue_connection() {
        //Arrange
        let sut: Restler.Header.Key = .connection
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Connection")
    }
    
    func testRawValue_contentEncoding() {
        //Arrange
        let sut: Restler.Header.Key = .contentEncoding
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Content-Encoding")
    }
    
    func testRawValue_contentLength() {
        //Arrange
        let sut: Restler.Header.Key = .contentLength
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Content-Length")
    }
    
    func testRawValue_contentMD5() {
        //Arrange
        let sut: Restler.Header.Key = .contentMD5
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Content-MD5")
    }
    
    func testRawValue_contentType() {
        //Arrange
        let sut: Restler.Header.Key = .contentType
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Content-Type")
    }
    
    func testRawValue_cookie() {
        //Arrange
        let sut: Restler.Header.Key = .cookie
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Cookie")
    }
    
    func testRawValue_date() {
        //Arrange
        let sut: Restler.Header.Key = .date
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Date")
    }
    
    func testRawValue_expect() {
        //Arrange
        let sut: Restler.Header.Key = .expect
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Expect")
    }
    
    func testRawValue_forwarded() {
        //Arrange
        let sut: Restler.Header.Key = .forwarded
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Forwarded")
    }
    
    func testRawValue_from() {
        //Arrange
        let sut: Restler.Header.Key = .from
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "From")
    }
    
    func testRawValue_host() {
        //Arrange
        let sut: Restler.Header.Key = .host
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Host")
    }
    
    func testRawValue_http2Settings() {
        //Arrange
        let sut: Restler.Header.Key = .http2Settings
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "HTTP2-Settings")
    }
    
    func testRawValue_ifMatch() {
        //Arrange
        let sut: Restler.Header.Key = .ifMatch
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "If-Match")
    }
    
    func testRawValue_ifModifiedSince() {
        //Arrange
        let sut: Restler.Header.Key = .ifModifiedSince
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "If-Modified-Since")
    }
    
    func testRawValue_ifNoneMatch() {
        //Arrange
        let sut: Restler.Header.Key = .ifNoneMatch
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "If-None-Match")
    }
    
    func testRawValue_ifRange() {
        //Arrange
        let sut: Restler.Header.Key = .ifRange
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "If-Range")
    }
    
    func testRawValue_ifUnmodifiedSince() {
        //Arrange
        let sut: Restler.Header.Key = .ifUnmodifiedSince
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "If-Unmodified-Since")
    }
    
    func testRawValue_maxForwards() {
        //Arrange
        let sut: Restler.Header.Key = .maxForwards
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Max-Forwards")
    }
    
    func testRawValue_origin() {
        //Arrange
        let sut: Restler.Header.Key = .origin
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Origin")
    }
    
    func testRawValue_pragma() {
        //Arrange
        let sut: Restler.Header.Key = .pragma
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Pragma")
    }
    
    func testRawValue_proxyAuthorization() {
        //Arrange
        let sut: Restler.Header.Key = .proxyAuthorization
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Proxy-Authorization")
    }
    
    func testRawValue_range() {
        //Arrange
        let sut: Restler.Header.Key = .range
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Range")
    }
    
    func testRawValue_referer() {
        //Arrange
        let sut: Restler.Header.Key = .referer
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Referer")
    }
    
    func testRawValue_te() {
        //Arrange
        let sut: Restler.Header.Key = .te
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "TE")
    }
    
    func testRawValue_trailer() {
        //Arrange
        let sut: Restler.Header.Key = .trailer
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Trailer")
    }
    
    func testRawValue_transferEncoding() {
        //Arrange
        let sut: Restler.Header.Key = .transferEncoding
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Transfer-Encoding")
    }
    
    func testRawValue_userAgent() {
        //Arrange
        let sut: Restler.Header.Key = .userAgent
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "User-Agent")
    }
    
    func testRawValue_upgrade() {
        //Arrange
        let sut: Restler.Header.Key = .upgrade
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Upgrade")
    }
    
    func testRawValue_via() {
        //Arrange
        let sut: Restler.Header.Key = .via
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Via")
    }
    
    func testRawValue_warning() {
        //Arrange
        let sut: Restler.Header.Key = .warning
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, "Warning")
    }
    
    func testRawValue_custom() {
        //Arrange
        let key = "some random key"
        let sut: Restler.Header.Key = .custom(key)
        //Act
        let rawValue = sut.rawValue
        //Assert
        XCTAssertEqual(rawValue, key)
    }
}

// MARK: - init(stringLiteral:)
extension HeaderKeyTests {
    func testInitFromStringLiteral_a_im() {
        //Arrange
        let expectedValue: Restler.Header.Key = .a_im
        //Act
        let sut: Restler.Header.Key = "A-IM"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_accept() {
        //Arrange
        let expectedValue: Restler.Header.Key = .accept
        //Act
        let sut: Restler.Header.Key = "Accept"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_acceptCharset() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptCharset
        //Act
        let sut: Restler.Header.Key = "Accept-Charset"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_acceptDatetime() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptDatetime
        //Act
        let sut: Restler.Header.Key = "Accept-Datetime"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_acceptEncoding() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptEncoding
        //Act
        let sut: Restler.Header.Key = "Accept-Encoding"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_acceptLanguage() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptLanguage
        //Act
        let sut: Restler.Header.Key = "Accept-Language"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_accessControlRequestMethod() {
        //Arrange
        let expectedValue: Restler.Header.Key = .accessControlRequestMethod
        //Act
        let sut: Restler.Header.Key = "Access-Control-Request-Method"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_accessControlRequestHeaders() {
        //Arrange
        let expectedValue: Restler.Header.Key = .accessControlRequestHeaders
        //Act
        let sut: Restler.Header.Key = "Access-Control-Request-Headers"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_authorization() {
        //Arrange
        let expectedValue: Restler.Header.Key = .authorization
        //Act
        let sut: Restler.Header.Key = "Authorization"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_cacheControl() {
        //Arrange
        let expectedValue: Restler.Header.Key = .cacheControl
        //Act
        let sut: Restler.Header.Key = "Cache-Control"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_connection() {
        //Arrange
        let expectedValue: Restler.Header.Key = .connection
        //Act
        let sut: Restler.Header.Key = "Connection"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_contentEncoding() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentEncoding
        //Act
        let sut: Restler.Header.Key = "Content-Encoding"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_contentLength() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentLength
        //Act
        let sut: Restler.Header.Key = "Content-Length"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_contentMD5() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentMD5
        //Act
        let sut: Restler.Header.Key = "Content-MD5"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_contentType() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentType
        //Act
        let sut: Restler.Header.Key = "Content-Type"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_cookie() {
        //Arrange
        let expectedValue: Restler.Header.Key = .cookie
        //Act
        let sut: Restler.Header.Key = "Cookie"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_date() {
        //Arrange
        let expectedValue: Restler.Header.Key = .date
        //Act
        let sut: Restler.Header.Key = "Date"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_expect() {
        //Arrange
        let expectedValue: Restler.Header.Key = .expect
        //Act
        let sut: Restler.Header.Key = "Expect"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_forwarded() {
        //Arrange
        let expectedValue: Restler.Header.Key = .forwarded
        //Act
        let sut: Restler.Header.Key = "Forwarded"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_from() {
        //Arrange
        let expectedValue: Restler.Header.Key = .from
        //Act
        let sut: Restler.Header.Key = "From"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_host() {
        //Arrange
        let expectedValue: Restler.Header.Key = .host
        //Act
        let sut: Restler.Header.Key = "Host"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_http2Settings() {
        //Arrange
        let expectedValue: Restler.Header.Key = .http2Settings
        //Act
        let sut: Restler.Header.Key = "HTTP2-Settings"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_ifMatch() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifMatch
        //Act
        let sut: Restler.Header.Key = "If-Match"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_ifModifiedSince() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifModifiedSince
        //Act
        let sut: Restler.Header.Key = "If-Modified-Since"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_ifNoneMatch() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifNoneMatch
        //Act
        let sut: Restler.Header.Key = "If-None-Match"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_ifRange() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifRange
        //Act
        let sut: Restler.Header.Key = "If-Range"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_ifUnmodifiedSince() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifUnmodifiedSince
        //Act
        let sut: Restler.Header.Key = "If-Unmodified-Since"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_maxForwards() {
        //Arrange
        let expectedValue: Restler.Header.Key = .maxForwards
        //Act
        let sut: Restler.Header.Key = "Max-Forwards"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_origin() {
        //Arrange
        let expectedValue: Restler.Header.Key = .origin
        //Act
        let sut: Restler.Header.Key = "Origin"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_pragma() {
        //Arrange
        let expectedValue: Restler.Header.Key = .pragma
        //Act
        let sut: Restler.Header.Key = "Pragma"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_proxyAuthorization() {
        //Arrange
        let expectedValue: Restler.Header.Key = .proxyAuthorization
        //Act
        let sut: Restler.Header.Key = "Proxy-Authorization"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_range() {
        //Arrange
        let expectedValue: Restler.Header.Key = .range
        //Act
        let sut: Restler.Header.Key = "Range"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_referer() {
        //Arrange
        let expectedValue: Restler.Header.Key = .referer
        //Act
        let sut: Restler.Header.Key = "Referer"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_te() {
        //Arrange
        let expectedValue: Restler.Header.Key = .te
        //Act
        let sut: Restler.Header.Key = "TE"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_trailer() {
        //Arrange
        let expectedValue: Restler.Header.Key = .trailer
        //Act
        let sut: Restler.Header.Key = "Trailer"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_transferEncoding() {
        //Arrange
        let expectedValue: Restler.Header.Key = .transferEncoding
        //Act
        let sut: Restler.Header.Key = "Transfer-Encoding"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_userAgent() {
        //Arrange
        let expectedValue: Restler.Header.Key = .userAgent
        //Act
        let sut: Restler.Header.Key = "User-Agent"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_upgrade() {
        //Arrange
        let expectedValue: Restler.Header.Key = .upgrade
        //Act
        let sut: Restler.Header.Key = "Upgrade"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_via() {
        //Arrange
        let expectedValue: Restler.Header.Key = .via
        //Act
        let sut: Restler.Header.Key = "Via"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_warning() {
        //Arrange
        let expectedValue: Restler.Header.Key = .warning
        //Act
        let sut: Restler.Header.Key = "Warning"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromStringLiteral_custom() {
        //Arrange
        let expectedValue: Restler.Header.Key = .custom("some random key")
        //Act
        let sut: Restler.Header.Key = "some random key"
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
}

// MARK: - init(rawValue:)
extension HeaderKeyTests {
    func testInitFromRawValue_a_im() {
        //Arrange
        let expectedValue: Restler.Header.Key = .a_im
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_accept() {
        //Arrange
        let expectedValue: Restler.Header.Key = .accept
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_acceptCharset() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptCharset
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_acceptDatetime() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptDatetime
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_acceptEncoding() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptEncoding
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_acceptLanguage() {
        //Arrange
        let expectedValue: Restler.Header.Key = .acceptLanguage
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_accessControlRequestMethod() {
        //Arrange
        let expectedValue: Restler.Header.Key = .accessControlRequestMethod
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_accessControlRequestHeaders() {
        //Arrange
        let expectedValue: Restler.Header.Key = .accessControlRequestHeaders
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_authorization() {
        //Arrange
        let expectedValue: Restler.Header.Key = .authorization
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_cacheControl() {
        //Arrange
        let expectedValue: Restler.Header.Key = .cacheControl
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_connection() {
        //Arrange
        let expectedValue: Restler.Header.Key = .connection
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_contentEncoding() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentEncoding
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_contentLength() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentLength
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_contentMD5() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentMD5
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_contentType() {
        //Arrange
        let expectedValue: Restler.Header.Key = .contentType
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_cookie() {
        //Arrange
        let expectedValue: Restler.Header.Key = .cookie
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_date() {
        //Arrange
        let expectedValue: Restler.Header.Key = .date
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_expect() {
        //Arrange
        let expectedValue: Restler.Header.Key = .expect
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_forwarded() {
        //Arrange
        let expectedValue: Restler.Header.Key = .forwarded
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_from() {
        //Arrange
        let expectedValue: Restler.Header.Key = .from
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_host() {
        //Arrange
        let expectedValue: Restler.Header.Key = .host
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_http2Settings() {
        //Arrange
        let expectedValue: Restler.Header.Key = .http2Settings
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_ifMatch() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifMatch
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_ifModifiedSince() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifModifiedSince
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_ifNoneMatch() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifNoneMatch
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_ifRange() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifRange
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_ifUnmodifiedSince() {
        //Arrange
        let expectedValue: Restler.Header.Key = .ifUnmodifiedSince
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_maxForwards() {
        //Arrange
        let expectedValue: Restler.Header.Key = .maxForwards
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_origin() {
        //Arrange
        let expectedValue: Restler.Header.Key = .origin
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_pragma() {
        //Arrange
        let expectedValue: Restler.Header.Key = .pragma
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_proxyAuthorization() {
        //Arrange
        let expectedValue: Restler.Header.Key = .proxyAuthorization
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_range() {
        //Arrange
        let expectedValue: Restler.Header.Key = .range
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_referer() {
        //Arrange
        let expectedValue: Restler.Header.Key = .referer
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_te() {
        //Arrange
        let expectedValue: Restler.Header.Key = .te
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_trailer() {
        //Arrange
        let expectedValue: Restler.Header.Key = .trailer
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_transferEncoding() {
        //Arrange
        let expectedValue: Restler.Header.Key = .transferEncoding
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_userAgent() {
        //Arrange
        let expectedValue: Restler.Header.Key = .userAgent
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_upgrade() {
        //Arrange
        let expectedValue: Restler.Header.Key = .upgrade
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_via() {
        //Arrange
        let expectedValue: Restler.Header.Key = .via
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_warning() {
        //Arrange
        let expectedValue: Restler.Header.Key = .warning
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
    
    func testInitFromRawValue_custom() {
        //Arrange
        let expectedValue: Restler.Header.Key = .custom("some random key")
        //Act
        let sut = Restler.Header.Key(rawValue: expectedValue.rawValue)
        //Assert
        XCTAssertEqual(sut, expectedValue)
    }
}
// swiftlint:disable:this file_length
