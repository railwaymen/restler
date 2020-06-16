**STRUCT**

# `Restler.Header`

> Header wrapper structure for Restler framework.

## Properties
### `dict`

> Dictionary representation of the header.

## Methods
### `init(_:)`

> Default init for the Header.
>
> - Parameters:
>   - header: Dictionary to put into the newly initialized Header.

### `removeValue(forKey:)`

> Function for removing value in the dictionary.
>
> If you don't need the returned value, you can use subscript instead.
>
> - Parameters:
>   - key: Key to remove value for.
>
> - Returns: True if value for the key existed

### `setBasicAuthorization(username:password:)`

> Encodes username and password into basic authorization header field.
>
> - Parameters:
>   - username: The username for the basic authentication.
>   - password: The password for the basic authentication.
