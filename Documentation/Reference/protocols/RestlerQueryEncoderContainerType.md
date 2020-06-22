**PROTOCOL**

# `RestlerQueryEncoderContainerType`

```swift
public protocol RestlerQueryEncoderContainerType: class
```

## Methods
### `encode(_:forKey:)`

```swift
func encode(_ value: RestlerStringEncodable?, forKey key: Key) throws
```

### `encode(_:forKey:)`

```swift
func encode(_ value: [RestlerStringEncodable]?, forKey key: Key) throws
```

### `encode(_:forKey:)`

```swift
func encode(_ value: [String: RestlerStringEncodable]?, forKey key: Key) throws
```

### `encode(_:forKey:)`

```swift
func encode(_ value: Date?, forKey key: Key) throws
```
