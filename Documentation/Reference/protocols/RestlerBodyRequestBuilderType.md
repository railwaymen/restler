**PROTOCOL**

# `RestlerBodyRequestBuilderType`

```swift
public protocol RestlerBodyRequestBuilderType: RestlerBasicRequestBuilderType
```

## Methods
### `body(_:)`

```swift
func body<E>(_ object: E) -> Self where E: Encodable
```

Sets body of the request.

If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.

- Parameters:
  - object: An encodable object.

- Returns: `self` for chaining.

#### Parameters

| Name | Description |
| ---- | ----------- |
| object | An encodable object. |