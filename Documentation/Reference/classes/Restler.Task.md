**CLASS**

# `Restler.Task`

## Properties
### `identifier`

> The identifier of the task

### `state`

> Current state of the task

## Methods
### `cancel()`

> Cancel the task.
>
> After calling this, completion of the task is called with error `Restler.Error.requestCancelled`.

### `suspend()`

> Suspend the task.
>
> A task, while suspended, produces no network traffic and is not subject to timeouts.
> A download task can continue transferring data at a later time. All other tasks must start over when resumed.

### `resume()`

> Resume the task, if it is suspended.
