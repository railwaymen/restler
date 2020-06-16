**PROTOCOL**

# `RestlerBodyRequestBuilderType`

## Methods
### `body(_:)`

> Sets body of the request.
>
> If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.
>
> - Parameters:
>   - object: An encodable object.
>
> - Returns: `self` for chaining.
