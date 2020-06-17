**CLASS**

# `Restler`

```swift
open class Restler: RestlerType
```

Class for making requests to the API

## Properties
### `encoder`

```swift
open var encoder: RestlerJSONEncoderType
```

### `decoder`

```swift
open var decoder: RestlerJSONDecoderType
```

### `errorParser`

```swift
open var errorParser: RestlerErrorParserType
```

### `header`

```swift
open var header: Restler.Header = .init()
```

## Methods
### `init(baseURL:encoder:decoder:)`

```swift
public convenience init(
    baseURL: URL,
    encoder: RestlerJSONEncoderType = JSONEncoder(),
    decoder: RestlerJSONDecoderType = JSONDecoder()
)
```

Default initializer.

- Parameters:
  - baseURL: Base for endpoints calls.
  - encoder: Encoder used for encoding requests' body.
  - decoder: Decoder used for decoding response's data to expected object.

#### Parameters

| Name | Description |
| ---- | ----------- |
| baseURL | Base for endpoints calls. |
| encoder | Encoder used for encoding requests’ body. |
| decoder | Decoder used for decoding response’s data to expected object. |

### `get(_:)`

```swift
open func get(_ endpoint: RestlerEndpointable) -> RestlerGetRequestBuilderType
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `post(_:)`

```swift
open func post(_ endpoint: RestlerEndpointable) -> RestlerPostRequestBuilderType
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `put(_:)`

```swift
open func put(_ endpoint: RestlerEndpointable) -> RestlerPutRequestBuilderType
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `patch(_:)`

```swift
open func patch(_ endpoint: RestlerEndpointable) -> RestlerPatchRequestBuilderType
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `delete(_:)`

```swift
open func delete(_ endpoint: RestlerEndpointable) -> RestlerDeleteRequestBuilderType
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |

### `head(_:)`

```swift
open func head(_ endpoint: RestlerEndpointable) -> RestlerHeadRequestBuilderType
```

#### Parameters

| Name | Description |
| ---- | ----------- |
| endpoint | Endpoint for the request |