import Foundation

extension Restler {
    public struct MultipartObject: Codable {
        public var filename: String?
        public var contentType: String?
        public var body: Data
        
        // MARK: - Initialization
        public init(filename: String?, contentType: String?, body: Data) {
            self.filename = filename
            self.contentType = contentType
            self.body = body
        }
    }
}
