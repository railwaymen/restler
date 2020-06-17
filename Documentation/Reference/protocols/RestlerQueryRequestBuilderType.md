**PROTOCOL**

# `RestlerQueryRequestBuilderType`

```swift
public protocol RestlerQueryRequestBuilderType: RestlerBasicRequestBuilderType
```

## Methods
### `query(_:)`

```swift
func query<E>(_ object: E) -> Self where E: RestlerQueryEncodable
```

Query encoded parameters.

If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.

- Parameters:
  - object: A query encodable object.

- Returns: `self` for chaining.

#### Parameters

| Name | Description |
| ---- | ----------- |
| object | A query encodable object. |