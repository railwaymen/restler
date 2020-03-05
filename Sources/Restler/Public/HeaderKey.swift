import Foundation

extension Restler.Header {
    
    /// Key for the header.
    ///
    /// If you need to use your own key, use
    /// ```
    /// .custom("Your_Custom_Key")
    /// ```
    public enum Key: Hashable {
        case a_im
        case accept
        case acceptCharset
        case acceptDatetime
        case acceptEncoding
        case acceptLanguage
        case accessControlRequestMethod
        case accessControlRequestHeaders
        case authorization
        case cacheControl
        case connection
        case contentEncoding
        case contentLength
        case contentMD5
        case contentType
        case cookie
        case date
        case expect
        case forwarded
        case from
        case host
        case http2Settings
        case ifMatch
        case ifModifiedSince
        case ifNoneMatch
        case ifRange
        case ifUnmodifiedSince
        case maxForwards
        case origin
        case pragma
        case proxyAuthorization
        case range
        case referer
        case te
        case trailer
        case transferEncoding
        case userAgent
        case upgrade
        case via
        case warning
        
        case custom(String)
        
        // MARK: - Static
        static let staticCases: Set<Key> = [
            .a_im,
            .accept,
            .acceptCharset,
            .acceptDatetime,
            .acceptEncoding,
            .acceptLanguage,
            .accessControlRequestMethod,
            .accessControlRequestHeaders,
            .authorization,
            .cacheControl,
            .connection,
            .contentEncoding,
            .contentLength,
            .contentMD5,
            .contentType,
            .cookie,
            .date,
            .expect,
            .forwarded,
            .from,
            .host,
            .http2Settings,
            .ifMatch,
            .ifModifiedSince,
            .ifNoneMatch,
            .ifRange,
            .ifUnmodifiedSince,
            .maxForwards,
            .origin,
            .pragma,
            .proxyAuthorization,
            .range,
            .referer,
            .te,
            .trailer,
            .transferEncoding,
            .userAgent,
            .upgrade,
            .via,
            .warning
        ]
        
        // MARK: - Getters
        var rawValue: String {
            switch self {
            case .a_im: return "A-IM"
            case .accept: return "Accept"
            case .acceptCharset: return "Accept-Charset"
            case .acceptDatetime: return "Accept-Datetime"
            case .acceptEncoding: return "Accept-Encoding"
            case .acceptLanguage: return "Accept-Language"
            case .accessControlRequestMethod: return "Access-Control-Request-Method"
            case .accessControlRequestHeaders: return "Access-Control-Request-Headers"
            case .authorization: return "Authorization"
            case .cacheControl: return "Cache-Control"
            case .connection: return "Connection"
            case .contentEncoding: return "Content-Encoding"
            case .contentLength: return "Content-Length"
            case .contentMD5: return "Content-MD5"
            case .contentType: return "Content-Type"
            case .cookie: return "Cookie"
            case .date: return "Date"
            case .expect: return "Expect"
            case .forwarded: return "Forwarded"
            case .from: return "From"
            case .host: return "Host"
            case .http2Settings: return "HTTP2-Settings"
            case .ifMatch: return "If-Match"
            case .ifModifiedSince: return "If-Modified-Since"
            case .ifNoneMatch: return "If-None-Match"
            case .ifRange: return "If-Range"
            case .ifUnmodifiedSince: return "If-Unmodified-Since"
            case .maxForwards: return "Max-Forwards"
            case .origin: return "Origin"
            case .pragma: return "Pragma"
            case .proxyAuthorization: return "Proxy-Authorization"
            case .range: return "Range"
            case .referer: return "Referer"
            case .te: return "TE"
            case .trailer: return "Trailer"
            case .transferEncoding: return "Transfer-Encoding"
            case .userAgent: return "User-Agent"
            case .upgrade: return "Upgrade"
            case .via: return "Via"
            case .warning: return "Warning"
                
            case let .custom(string): return string
            }
        }
        
        // MARK: - Initialization
        init(rawValue: String) {
            self = Key.staticCases.first { $0.rawValue == rawValue }
                ?? .custom(rawValue)
        }
    }
}
