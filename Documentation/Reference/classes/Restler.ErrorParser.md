**CLASS**

# `Restler.ErrorParser`

```swift
open class ErrorParser: RestlerErrorParserType
```

## Methods
### `init(decodingErrors:)`

```swift
public init(decodingErrors: [RestlerErrorDecodable.Type] = [])
```

### `decode(_:)`

```swift
open func decode<T>(_ type: T.Type) where T: RestlerErrorDecodable
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | A type for the error to be decoded. It will be added to an array of errors to decode on failed request. |

### `stopDecoding(_:)`

```swift
open func stopDecoding<T>(_ type: T.Type) where T: RestlerErrorDecodable
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | An error type to remove from decoding errors array. |

### `copy()`

```swift
open func copy() -> RestlerErrorParserType
```

### `parse(_:)`

```swift
open func parse(_ error: Swift.Error) -> Swift.Error
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| error | An error to be parsed. |