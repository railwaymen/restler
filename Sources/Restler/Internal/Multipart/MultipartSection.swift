import Foundation

extension Restler {
    internal struct MultipartSection {
        var key: String
        var filename: String?
        var contentType: String?
        var body: Data
        
        private var lineBreak: String {
            Restler.MultipartEncoder.lineBreak
        }
        
        // MARK: Internal functions
        func buildSectionData(boundary: String) -> Data {
            var data = Data()
            data.append(self.buildBoundary(boundary))
            data.append(self.getFirstHeader())
            data.append(self.getSecondHeader())
            data.append(self.lineBreak)
            data.append(self.body)
            data.append(self.lineBreak)
            return data
        }
        
        // MARK: - Private
        private func buildBoundary(_ boundary: String) -> String {
            return "--" + boundary + self.lineBreak
        }
        
        private func getFirstHeader() -> String {
            if let filename = self.filename {
                return #"Content-Disposition: form-data; name="\#(self.key)"; filename="\#(filename)"\#(self.lineBreak)"#
            } else {
                return #"Content-Disposition: form-data; name="\#(self.key)"\#(self.lineBreak)"#
            }
        }
        
        private func getSecondHeader() -> String {
            guard let contentType = self.contentType else { return "" }
            return #"Content-Type: \#(contentType + self.lineBreak)"#
        }
    }
}
