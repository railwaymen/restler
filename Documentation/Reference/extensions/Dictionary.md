**EXTENSION**

# `Dictionary`
```swift
extension Dictionary: RestlerQueryEncodable where Key == String, Value: RestlerStringEncodable
```

## Methods
### `encodeToQuery(using:)`

```swift
public func encodeToQuery(using encoder: RestlerQueryEncoderType) throws
```
