import Foundation
import Restler

final class RestlerErrorParserMock {
    
    // MARK: - RestlerErrorParserType
    var decodingErrorsReturnValue: [RestlerErrorDecodable.Type] = []
    private(set) var decodingErrorsSetValues: [[RestlerErrorDecodable.Type]] = []
    
    private(set) var decodeParams: [DecodeParams] = []
    struct DecodeParams {
        let type: Any
    }
    
    private(set) var stopDecoding: [StopDecoding] = []
    struct StopDecoding {
        let type: Any
    }
    
    private(set) var copyParams: [CopyParams] = []
    struct CopyParams {}
    
    private(set) var parseParams: [ParseParams] = []
    struct ParseParams {
        let error: Error
    }
}

// MARK: - RestlerErrorParserType
extension RestlerErrorParserMock: RestlerErrorParserType {
    var decodingErrors: [RestlerErrorDecodable.Type] {
        get {
            self.decodingErrorsReturnValue
        }
        set {
            self.decodingErrorsSetValues.append(newValue)
        }
    }
    
    func decode<T>(_ type: T.Type) where T: RestlerErrorDecodable {
        self.decodeParams.append(DecodeParams(type: type))
    }
    
    func stopDecoding<T>(_ type: T.Type) where T: RestlerErrorDecodable {
        self.stopDecoding.append(StopDecoding(type: type))
    }
    
    func copy() -> RestlerErrorParserType {
        self.copyParams.append(CopyParams())
        return self
    }
    
    func parse(_ error: Error) -> Error {
        self.parseParams.append(ParseParams(error: error))
        return error
    }
}
