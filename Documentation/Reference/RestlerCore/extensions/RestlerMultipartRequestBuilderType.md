**EXTENSION**

# `RestlerMultipartRequestBuilderType`

## Methods
### `multipart(_:)`

Sets body of the request.

If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.

- Parameters:
  - object: A multipart encodable object.

- Returns: `self` for chaining.
