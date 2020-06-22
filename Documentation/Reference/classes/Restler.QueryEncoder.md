**CLASS**

# `Restler.QueryEncoder`

```swift
public class QueryEncoder: RestlerQueryEncoderType
```

## Methods
### `init(jsonEncoder:)`

```swift
public init(jsonEncoder: RestlerJSONEncoderType)
```

### `container(using:)`

```swift
public func container<Key: CodingKey>(using _: Key.Type) -> KeyedContainer<Key>
```

### `stringKeyedContainer()`

```swift
public func stringKeyedContainer() -> StringKeyedContainer
```

### `encode(_:)`

```swift
public func encode<T: RestlerQueryEncodable>(_ object: T) throws -> [URLQueryItem]
```
