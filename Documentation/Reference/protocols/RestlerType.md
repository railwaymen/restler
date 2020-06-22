**PROTOCOL**

# `RestlerType`

```swift
public protocol RestlerType: class
```

Interface of the main functional class of the Restler framework.

## Properties
### `encoder`

```swift
var encoder: RestlerJSONEncoderType
```

Encoder used for encoding requests' body.

### `decoder`

```swift
var decoder: RestlerJSONDecoderType
```

Decoder used for decoding response's data to expected object.

### `errorParser`

```swift
var errorParser: RestlerErrorParserType
```

Error parser for failed requests. Setting its decoded errors makes trying to decode them globally.

### `header`

```swift
var header: Restler.Header
```

Global header sent in requests.

## Methods
### `get(_:)`

```swift
func get(_ endpoint: RestlerEndpointable) -> RestlerGetRequestBuilderType
```

Creates GET request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `post(_:)`

```swift
func post(_ endpoint: RestlerEndpointable) -> RestlerPostRequestBuilderType
```

Creates POST request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `put(_:)`

```swift
func put(_ endpoint: RestlerEndpointable) -> RestlerPutRequestBuilderType
```

Creates PUT request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `patch(_:)`

```swift
func patch(_ endpoint: RestlerEndpointable) -> RestlerPatchRequestBuilderType
```

Creates PATCH request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `delete(_:)`

```swift
func delete(_ endpoint: RestlerEndpointable) -> RestlerDeleteRequestBuilderType
```

Creates DELETE request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `head(_:)`

```swift
func head(_ endpoint: RestlerEndpointable) -> RestlerHeadRequestBuilderType
```

Creates HEAD request builder.

- Parameter endpoint: Endpoint for the request

- Returns: Restler.RequestBuilder for building the request in the functional way.

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |