**ENUM**

# `Restler.Header.Key`

```swift
public enum Key: Hashable, ExpressibleByStringLiteral
```

Key for the header.

If you need to use your own key, use
```
.custom("Your_Custom_Key")
```

## Cases
### `a_im`

```swift
case a_im
```

### `accept`

```swift
case accept
```

### `acceptCharset`

```swift
case acceptCharset
```

### `acceptDatetime`

```swift
case acceptDatetime
```

### `acceptEncoding`

```swift
case acceptEncoding
```

### `acceptLanguage`

```swift
case acceptLanguage
```

### `accessControlRequestMethod`

```swift
case accessControlRequestMethod
```

### `accessControlRequestHeaders`

```swift
case accessControlRequestHeaders
```

### `authorization`

```swift
case authorization
```

### `cacheControl`

```swift
case cacheControl
```

### `connection`

```swift
case connection
```

### `contentEncoding`

```swift
case contentEncoding
```

### `contentLength`

```swift
case contentLength
```

### `contentMD5`

```swift
case contentMD5
```

### `contentType`

```swift
case contentType
```

### `cookie`

```swift
case cookie
```

### `date`

```swift
case date
```

### `expect`

```swift
case expect
```

### `forwarded`

```swift
case forwarded
```

### `from`

```swift
case from
```

### `host`

```swift
case host
```

### `http2Settings`

```swift
case http2Settings
```

### `ifMatch`

```swift
case ifMatch
```

### `ifModifiedSince`

```swift
case ifModifiedSince
```

### `ifNoneMatch`

```swift
case ifNoneMatch
```

### `ifRange`

```swift
case ifRange
```

### `ifUnmodifiedSince`

```swift
case ifUnmodifiedSince
```

### `maxForwards`

```swift
case maxForwards
```

### `origin`

```swift
case origin
```

### `pragma`

```swift
case pragma
```

### `proxyAuthorization`

```swift
case proxyAuthorization
```

### `range`

```swift
case range
```

### `referer`

```swift
case referer
```

### `te`

```swift
case te
```

### `trailer`

```swift
case trailer
```

### `transferEncoding`

```swift
case transferEncoding
```

### `userAgent`

```swift
case userAgent
```

### `upgrade`

```swift
case upgrade
```

### `via`

```swift
case via
```

### `warning`

```swift
case warning
```

### `custom(_:)`

```swift
case custom(String)
```

## Methods
### `init(stringLiteral:)`

```swift
public init(stringLiteral value: String)
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| value | The value of the new instance. |