**PROTOCOL**

# `RestlerErrorDecodable`

```swift
public protocol RestlerErrorDecodable: Error
```

A protocol for the decodable error for Restler framework.

## Methods
### `init(response:)`

```swift
init?(response: Restler.Response)
```

The initializer for the error.

Returning nil in this initializer means to the Restler framework, that decoding has failed.
So the error won't be decoded if the init returns nil.

- Parameters:
  - response: Response of the failed request.

#### Parameters

| Name | Description |
| ---- | ----------- |
| response | Response of the failed request. |