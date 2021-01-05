**PROTOCOL**

# `RestlerType`

Interface of the main functional class of the Restler framework.

## Properties
### `encoder`

Encoder used for encoding requests' body.

### `decoder`

Decoder used for decoding response's data to expected object.

### `errorParser`

Error parser for failed requests. Setting its decoded errors makes trying to decode them globally.

### `header`

Global header sent in requests.

### `levelOfLogDetails`

A level of details in logs displayed in the console. Logs are displaying only for DEBUG builds.

## Methods
### `get(_:)`

Creates GET request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

### `post(_:)`

Creates POST request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

### `put(_:)`

Creates PUT request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

### `patch(_:)`

Creates PATCH request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

### `delete(_:)`

Creates DELETE request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

### `head(_:)`

Creates HEAD request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.
