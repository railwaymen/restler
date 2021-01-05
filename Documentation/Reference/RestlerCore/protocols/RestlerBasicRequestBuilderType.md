**PROTOCOL**

# `RestlerBasicRequestBuilderType`

A request builder. Builds a request from the given data.

## Methods
### `setInHeader(_:forKey:)`

Sets custom value for the header in the single request.

Use this if you want to send a specific value in the header of a single request.
This value will override existing one in the header or will be added if header doesn't conint the key yet.

- Note:
  This function doesn't remove existing field in the header.

- Parameters:
  - value: A string value for the key. If nil, a value for the key will be removed.
  - key: A key for the value.

- Returns: `self` for chaining.

### `failureDecode(_:)`

Try to decode the error on failure of the data task.

If the request will end with error, the given error would be decoded if init of the error doesn't return nil.
Otherwise the Restler.Error.common will be returned.

- Note:
  If multiple errors will be decoded. The completion will return Restler.Error.multiple with all the decoded errors.

- Parameters:
  - type: A type for the error to be decoded. It will be added to an array of errors to decode on failed request.

- Returns: `self` for chaining.

### `customRequestModification(_:)`

Use for custom modifications of the URLRequest after setting it up with the builder's values.

- Parameters:
  - modification: A mutating function called just before beginning a data task for the request.

- Returns: `self` for chaining.

### `catching(_:)`

Calls handler if any error have occured during the request building proccess.

- Parameters:
  - handler: A closure called only if any error have occured while building the request.

- Returns: `self` for chaining.

### `receive(on:)`

Sets a dispatch queue on which finish handlers will be called.

Detault queue **IS NOT** the main queue and it's picked by the `URLSession`.

- Parameters:
  - queue: A dispatch queue on which finish handlers will be called. If nil, default queue will be use.

- Returns: `self` for chaining.

### `decode(_:)`

Builds a request with a decoding type.

Ignores any data received on the successful request.

- Parameters:
  - type: `Void.self`

- Returns: Appropriate request for the given type.

### `urlRequest()`

Builds a URLRequest instance and returns it.

- Returns: A URLRequest instance basing on provided data.
Returns nil if building error have occured. Handle the error using the `catching(_:)` function.

### `publisher()`

Builds a request and returns publisher for Combine support.

- Returns: DataTaskPublisher for support of Combine using.
Nil if building error have occured. Handle the error using the `catching(_:)` function.
