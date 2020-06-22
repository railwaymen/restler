**CLASS**

# `Restler.Request`

```swift
open class Request<D>: RestlerRequest
```

An API request.

## Methods
### `init()`

```swift
public init()
```

### `onSuccess(_:)`

```swift
open func onSuccess(_ handler: @escaping (D) -> Void) -> Self
```

Sets handler called on successful request response.

Called just before `onCompletion` handler.

- Parameters:
  - handler: A handler called on the request `.success` completion.

- Returns: `self` for chaining.

#### Parameters

| Name | Description |
| ---- | ----------- |
| handler | A handler called on the request `.success` completion. |

### `onFailure(_:)`

```swift
open func onFailure(_ handler: @escaping (Swift.Error) -> Void) -> Self
```

Sets handler called on failed request response.

Called just before `onCompletion` handler.

- Parameters:
  - handler: A handler called on the request `.failure` completion.

- Returns: `self` for chaining.

#### Parameters

| Name | Description |
| ---- | ----------- |
| handler | A handler called on the request `.failure` completion. |

### `onCompletion(_:)`

```swift
open func onCompletion(_ handler: @escaping (Result<D, Swift.Error>) -> Void) -> Self
```

Sets handler called on the completion of the request.

Called at the very end of the request.

- Parameters:
  - handler: A handler called on the request completion.

- Returns: `self` for chaining.

#### Parameters

| Name | Description |
| ---- | ----------- |
| handler | A handler called on the request completion. |

### `start()`

```swift
open func start() -> RestlerTaskType?
```

Starts the request.

This function have to be called to start the request.

- Warning:
  If the encoding of parameters is at 100% successful the returned nil means that Restler internal error have occured.
  Please contact the developers of the framework in this case.

- Returns:
  Restler.Task interface for managing the task (e.g. cancelling it) if the task is created properly.
  Returns nil if the task couldn't be created because of encoding errors.
