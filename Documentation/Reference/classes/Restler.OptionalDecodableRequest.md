**CLASS**

# `Restler.OptionalDecodableRequest`

```swift
public class OptionalDecodableRequest<D: Decodable>: Request<D?>, RestlerRequestInternal
```

## Methods
### `onSuccess(_:)`

```swift
public override func onSuccess(_ handler: @escaping (D?) -> Void) -> Self
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
public override func onCompletion(_ handler: @escaping Restler.DecodableCompletion<D?>) -> Self
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| handler | A handler called on the request completion. |

### `start()`

```swift
public override func start() -> RestlerTaskType?
```
