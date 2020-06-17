**STRUCT**

# `Restler.Header`

```swift
public struct Header: Equatable
```

Header wrapper structure for Restler framework.

## Properties
### `dict`

```swift
public var dict: [Key: String]
```

Dictionary representation of the header.

## Methods
### `init(_:)`

```swift
public init(_ header: [Key: String] = [:])
```

Default init for the Header.

- Parameters:
  - header: Dictionary to put into the newly initialized Header.

#### Parameters

| Name | Description |
| ---- | ----------- |
| header | Dictionary to put into the newly initialized Header. |

### `removeValue(forKey:)`

```swift
public mutating func removeValue(forKey key: Key) -> Bool
```

Function for removing value in the dictionary.

If you don't need the returned value, you can use subscript instead.

- Parameters:
  - key: Key to remove value for.

- Returns: True if value for the key existed

#### Parameters

| Name | Description |
| ---- | ----------- |
| key | Key to remove value for. |

### `setBasicAuthorization(username:password:)`

```swift
public mutating func setBasicAuthorization(username: String, password: String)
```

Encodes username and password into basic authorization header field.

- Parameters:
  - username: The username for the basic authentication.
  - password: The password for the basic authentication.

#### Parameters

| Name | Description |
| ---- | ----------- |
| username | The username for the basic authentication. |
| password | The password for the basic authentication. |