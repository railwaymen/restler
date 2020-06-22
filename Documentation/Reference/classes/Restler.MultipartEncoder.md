**CLASS**

# `Restler.MultipartEncoder`

```swift
public class MultipartEncoder: RestlerMultipartEncoderType
```

## Methods
### `container(using:)`

```swift
public func container<Key>(using _: Key.Type) -> Restler.MultipartEncoder.Container<Key> where Key: CodingKey
```

### `encode(_:boundary:)`

```swift
public func encode<T>(_ object: T, boundary: String) throws -> Data? where T: RestlerMultipartEncodable
```
