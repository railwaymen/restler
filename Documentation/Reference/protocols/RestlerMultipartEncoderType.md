**PROTOCOL**

# `RestlerMultipartEncoderType`

```swift
public protocol RestlerMultipartEncoderType: class
```

## Methods
### `container(using:)`

```swift
func container<Key>(using _: Key.Type) -> Restler.MultipartEncoder.Container<Key>
```

### `encode(_:boundary:)`

```swift
func encode<T>(_ object: T, boundary: String) throws -> Data? where T: RestlerMultipartEncodable
```
