**CLASS**

# `Restler.QueryEncoder.StringKeyedContainer`

```swift
public class StringKeyedContainer: RestlerQueryEncoderContainerType
```

## Methods
### `init(jsonEncoder:)`

```swift
public init(jsonEncoder: RestlerJSONEncoderType)
```

### `encode(_:forKey:)`

```swift
public func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws
```

### `encode(_:forKey:)`

```swift
public func encode(_ value: [RestlerStringEncodable]?, forKey key: String) throws
```

### `encode(_:forKey:)`

```swift
public func encode(_ value: [String: RestlerStringEncodable]?, forKey key: String) throws
```

### `encode(_:forKey:)`

```swift
public func encode(_ value: Date?, forKey key: String) throws
```
