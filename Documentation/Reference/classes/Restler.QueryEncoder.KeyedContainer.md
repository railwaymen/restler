**CLASS**

# `Restler.QueryEncoder.KeyedContainer`

```swift
public class KeyedContainer<Key: CodingKey>: RestlerQueryEncoderContainerType
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
public func encode(_ value: [RestlerStringEncodable]?, forKey key: Key) throws
```

### `encode(_:forKey:)`

```swift
public func encode(_ value: [String: RestlerStringEncodable]?, forKey key: Key) throws
```

### `encode(_:forKey:)`

```swift
public func encode(_ value: Date?, forKey key: Key) throws
```
