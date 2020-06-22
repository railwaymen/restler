**PROTOCOL**

# `RestlerQueryEncoderType`

```swift
public protocol RestlerQueryEncoderType
```

## Methods
### `container(using:)`

```swift
func container<Key: CodingKey>(using: Key.Type) -> Restler.QueryEncoder.KeyedContainer<Key>
```

### `stringKeyedContainer()`

```swift
func stringKeyedContainer() -> Restler.QueryEncoder.StringKeyedContainer
```

### `encode(_:)`

```swift
func encode<Key: RestlerQueryEncodable>(_ object: Key) throws -> [URLQueryItem]
```
