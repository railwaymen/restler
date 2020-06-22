**PROTOCOL**

# `RestlerJSONEncoderType`

```swift
public protocol RestlerJSONEncoderType: class
```

## Methods
### `encode(_:)`

```swift
func encode<T>(_ value: T) throws -> Data where T: Encodable
```
