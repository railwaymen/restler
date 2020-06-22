**CLASS**

# `Restler.Task`

```swift
open class Task: RestlerTaskType
```

## Properties
### `identifier`

```swift
open var identifier: Int
```

The identifier of the task

### `state`

```swift
open var state: URLSessionTask.State
```

Current state of the task

## Methods
### `cancel()`

```swift
open func cancel()
```

Cancel the task.

After calling this, completion of the task is called with error `Restler.Error.requestCancelled`.

### `suspend()`

```swift
open func suspend()
```

Suspend the task.

A task, while suspended, produces no network traffic and is not subject to timeouts.
A download task can continue transferring data at a later time. All other tasks must start over when resumed.

### `resume()`

```swift
open func resume()
```

Resume the task, if it is suspended.
