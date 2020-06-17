**CLASS**

# `Restler.VoidRequest`

```swift
public class VoidRequest: Request<Void>, RestlerRequestInternal
```

## Methods
### `onSuccess(_:)`

```swift
public override func onSuccess(_ handler: @escaping (SuccessfulResponseObject) -> Void) -> Self
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| handler | A handler called on the request `.success` completion. |

### `onFailure(_:)`

```swift
public override func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| handler | A handler called on the request `.failure` completion. |

### `onCompletion(_:)`

```swift
public override func onCompletion(_ handler: @escaping Restler.VoidCompletion) -> Self
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| handler | A handler called on the request completion. |

### `start()`

```swift
public override func start() -> RestlerTaskType?
```
