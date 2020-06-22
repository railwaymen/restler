**EXTENSION**

# `RestlerMultipartRequestBuilderType`
```swift
extension RestlerMultipartRequestBuilderType
```

## Methods
### `multipart(_:)`

```swift
public func multipart<E>(_ object: E) -> Self where E: RestlerMultipartEncodable
```

Sets body of the request.

If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.

- Parameters:
  - object: A multipart encodable object.

- Returns: `self` for chaining.

#### Parameters

| Name | Description |
| ---- | ----------- |
| object | A multipart encodable object. |