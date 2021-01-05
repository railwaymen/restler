**CLASS**

# `Restler.Request`

**Contents**

- [Methods](#methods)
  - `init()`
  - `onSuccess(_:)`
  - `onFailure(_:)`
  - `onCompletion(_:)`
  - `start()`
  - `using(session:)`
  - `subscribe(onSuccess:onFailure:onCompletion:)`

An API request.

## Methods
### `init()`

### `onSuccess(_:)`

Sets handler called on successful request response.

Called just before `onCompletion` handler.

- Parameters:
  - handler: A handler called on the request `.success` completion.

- Returns: `self` for chaining.

### `onFailure(_:)`

Sets handler called on failed request response.

Called just before `onCompletion` handler.

- Parameters:
  - handler: A handler called on the request `.failure` completion.

- Returns: `self` for chaining.

### `onCompletion(_:)`

Sets handler called on the completion of the request.

Called at the very end of the request.

- Parameters:
  - handler: A handler called on the request completion.

- Returns: `self` for chaining.

### `start()`

Starts the request.

This function have to be called to start the request.

- Warning:
  If the encoding of parameters is at 100% successful the returned nil
   means that Restler internal error have occured.
  Please contact the developers of the framework in this case.

- Returns:
  `Restler.Task` interface for managing the task (e.g. cancelling it) if the task is created properly.
  Returns `nil` if the task couldn't be created because of encoding errors.

### `using(session:)`

Sets the request to use the provided `URLSession` instead of the default one.

- Parameters:
  - session: A `URLSession` that will perform the built task. If not set, `shared` will be used.

- Returns: `self` for chaining.

### `subscribe(onSuccess:onFailure:onCompletion:)`

Runs networking task with specified handlers at its completion.

- Parameters:
  - onSuccess: A handler called on successful response.
  - object: A decoded object.

  - onFailure: A handler called when request has failed.
  - error: An error that occured during the request.

  - onCompletion: A handler called when request has finished.
  - result: A result of networking request with a decoded object or an error.

- Returns:
  `Restler.Task` interface for managing the task (e.g. cancelling it) if the task is created properly.
  Returns `nil` if the task couldn't be created because of encoding errors.
