**PROTOCOL**

# `RestlerDecodableResponseRequestBuilderType`

## Methods
### `decode(_:)`

> Builds a request with a decoding type.
>
> Optional decoding ignores the returned data if decoding of the given type failes.
> It returns success with nil in this case. So it is always successful if the data request was successful.
>
> - Parameters:
>   - type: Decodable object type to be decoded on the request completion.
>
> - Returns: Appropriate request for the given type.

### `decode(_:)`

> Builds a request with a decoding type.
>
> If decoding of the given type failes, completion will be called with `failure` containing the underlying error in the `Restler.Error.common`'s base.
>
> - Parameters:
>   - type: Decodable object type to be decoded on the request completion.
>
> - Returns: Appropriate request for the given type.
