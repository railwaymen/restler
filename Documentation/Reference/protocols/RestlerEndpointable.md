**PROTOCOL**

# `RestlerEndpointable`

```swift
public protocol RestlerEndpointable
```

Protocol describing endpoint representable object.

## Properties
### `restlerEndpointValue`

```swift
var restlerEndpointValue: String
```

The string value of the endpoint.

It should be in format `/path/for/request`.
It is appended to the base URL.
