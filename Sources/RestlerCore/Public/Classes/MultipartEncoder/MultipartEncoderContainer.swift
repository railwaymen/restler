import Foundation

extension Restler.MultipartEncoder {
    public final class Container<Key: CodingKey>: RestlerMultipartContainerType {
        internal var sections: [Restler.MultipartSection] = []
        
        // MARK: - Public
        public func encode(_ value: RestlerStringEncodable, forKey key: Key) throws {
            guard let data = value.restlerStringValue.data(using: .utf8) else {
                throw Restler.internalError()
            }
            self.sections.append(Restler.MultipartSection(key: key.stringValue, body: data))
        }
        
        public func encode(_ value: Restler.MultipartObject, forKey key: Key) throws {
            self.sections.append(Restler.MultipartSection(
                key: key.stringValue,
                filename: value.filename,
                contentType: value.contentType,
                body: value.body))
        }
    }
}

// MARK: - RestlerMultipartSectionsType
extension Restler.MultipartEncoder.Container: RestlerMultipartSectionsType {}
