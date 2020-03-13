import Foundation

public protocol RestlerStringEncodable {
    var restlerStringValue: String { get }
}

extension Decimal: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension Double: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension Float: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension Int: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension Int8: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension Int16: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension Int32: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension Int64: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension UInt: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension UInt8: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension UInt16: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension UInt32: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension UInt64: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}

extension String: RestlerStringEncodable {
    public var restlerStringValue: String {
        self
    }
}

extension URL: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.absoluteString
    }
}

extension UUID: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.uuidString
    }
}

extension Bool: RestlerStringEncodable {
    public var restlerStringValue: String {
        self.description
    }
}
