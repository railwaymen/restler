**ENUM**

# `Restler.Error`

```swift
public enum Error: Swift.Error
```

## Cases
### `common(type:base:)`

```swift
case common(type: ErrorType, base: Swift.Error)
```

### `request(type:response:)`

```swift
case request(type: ErrorType, response: Response)
```

### `multiple(_:)`

```swift
indirect case multiple([Error])
```
