**PROTOCOL**

# `RestlerErrorParserType`

```swift
public protocol RestlerErrorParserType
```

An object parsing the given error to given types of the RestlerErrorDecodables.

## Methods
### `decode(_:)`

```swift
func decode<T>(_ type: T.Type) where T: RestlerErrorDecodable
```

Try to decode the error on failure of the data task.

If the request will end with error, the given error would be decoded if init of the error doesn't return nil.
Otherwise the Restler.Error.common will be returned.

- Note:
  If multiple errors will be decoded. The completion will return Restler.Error.multiple with all the decoded errors.

- Parameters:
  - type: A type for the error to be decoded. It will be added to an array of errors to decode on failed request.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | A type for the error to be decoded. It will be added to an array of errors to decode on failed request. |

### `stopDecoding(_:)`

```swift
func stopDecoding<T>(_ type: T.Type) where T: RestlerErrorDecodable
```

Removed the given error type from the array of error types to decode.

- Parameters:
  - type: An error type to remove from decoding errors array.

#### Parameters

| Name | Description |
| ---- | ----------- |
| type | An error type to remove from decoding errors array. |

### `copy()`

```swift
func copy() -> RestlerErrorParserType
```

Creates a copy of the ErrorParser.

### `parse(_:)`

```swift
func parse(_ error: Swift.Error) -> Swift.Error
```

Tries to parse the given error into the decodable errors.

- Parameters:
  - error: An error to be parsed.

- Returns:
   - Decoded error if one of the errors were decoded successfully
   - `Restler.Error.multiple` if multiple errors were decoded.
   - The input error, if error couldn't be parsed to any other error type.

#### Parameters

| Name | Description |
| ---- | ----------- |
| error | An error to be parsed. |