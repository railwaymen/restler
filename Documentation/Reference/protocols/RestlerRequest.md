**PROTOCOL**

# `RestlerRequest`

```swift
public protocol RestlerRequest: class
```

## Methods
### `onSuccess(_:)`

```swift
func onSuccess(_ handler: @escaping (SuccessfulResponseObject) -> Void) -> Self
```

### `onFailure(_:)`

```swift
func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self
```

### `onCompletion(_:)`

```swift
func onCompletion(_ handler: @escaping (Result<SuccessfulResponseObject, Error>) -> Void) -> Self
```

### `start()`

```swift
func start() -> RestlerTaskType?
```
