import Foundation

public protocol RestlerType: class {
    var encoder: RestlerJSONEncoderType { get set }
    var decoder: RestlerJSONDecoderType { get set }
    var errorParser: RestlerErrorParserType { get set }
    var header: Restler.Header { get set }
    
    func get(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType
    func post(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType
    func put(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType
    func delete(_ endpoint: RestlerEndpointable) -> RestlerRequestBuilderType
}
