import Foundation

extension Restler {
    public class MultipartEncoder: RestlerMultipartEncoderType {
        internal static let lineBreak = "\r\n"
        
        private var containers: [RestlerMultipartSectionsType] = []
        
        // MARK: - Public
        public func container<Key>(using _: Key.Type) -> Restler.MultipartEncoder.Container<Key> where Key: CodingKey {
            let container = Container<Key>()
            self.containers.append(container)
            return container
        }
        
        public func encode<T>(_ object: T, boundary: String) throws -> Data? where T: RestlerMultipartEncodable {
            try object.encodeToMultipart(encoder: self)
            let sections = self.containers.flatMap { $0.sections }
            return self.build(from: sections, boundary: boundary)
        }
    }
}

// MARK: - Private
extension Restler.MultipartEncoder {
    private func build(from sections: [Restler.MultipartSection], boundary: String) -> Data? {
        var data: Data = sections.reduce(into: Data()) { result, section in
            result.append(section.buildSectionData(boundary: boundary))
        }
        data.append("--" + boundary + "--" + Self.lineBreak)
        return data
    }
}
