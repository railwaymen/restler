**PROTOCOL**

# `RestlerQueryRequestBuilderType`

## Methods
### `query(_:)`

> Query encoded parameters.
>
> If error while encoding occurs, it's returned in the completion of the request inside the `Restler.Error.multiple`.
>
> - Parameters:
>   - object: A query encodable object.
>
> - Returns: `self` for chaining.
