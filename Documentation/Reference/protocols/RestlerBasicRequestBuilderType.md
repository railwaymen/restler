**PROTOCOL**

# `RestlerBasicRequestBuilderType`

> A request builder. Builds a request from the given data.

## Methods
### `setInHeader(_:forKey:)`

> Sets custom value for the header in the single request.
>
> Use this if you want to send a specific value in the header of a single request.
> This value will override existing one in the header or will be added if header doesn't conint the key yet.
>
> - Note:
>   This function doesn't remove existing field in the header.
>
> - Parameters:
>   - value: A string value for the key. If nil, a value for the key will be removed.
>   - key: A key for the value.
>
> - Returns: `self` for chaining.

### `failureDecode(_:)`

> Try to decode the error on failure of the data task.
>
> If the request will end with error, the given error would be decoded if init of the error doesn't return nil.
> Otherwise the Restler.Error.common will be returned.
>
> - Note:
>   If multiple errors will be decoded. The completion will return Restler.Error.multiple with all the decoded errors.
>
> - Parameters:
>   - type: A type for the error to be decoded. It will be added to an array of errors to decode on failed request.
>
> - Returns: `self` for chaining.

### `decode(_:)`

> Builds a request with a decoding type.
>
> Ignores any data received on the successful request.
>
> - Parameters:
>   - type: `Void.self`
>
> - Returns: Appropriate request for the given type.
