import Foundation

final class FileReader {
    private let fileURL: URL
    private let dryRun: Bool
    private let fileManager: FileManager = .init()
    
    // MARK: - Initialization
    init(
        fileURL: URL,
        dryRun: Bool
    ) {
        self.fileURL = fileURL
        self.dryRun = dryRun
        
        guard dryRun else { return }
        console.info("FileReader: \(fileURL.path)")
    }
    
    // MARK: - Internal
    func replaceAll(regex: String, with text: String) {
        guard !dryRun else {
            console.info("replaceAll: \(regex) with: \(text)")
            return
        }
        guard var content = readFile() else { return }
        var newContent = content
        repeat {
            content = newContent
            newContent = replace(firstRegex: regex, with: text, in: content)
        } while content != newContent
        writeToFile(text: newContent)
    }
    
    func replace(firstRegex: String, with text: String) {
        guard !dryRun else {
            console.info("replaceFirst: \(firstRegex) with: \(text)")
            return
        }
        guard var content = readFile() else { return }
        content = replace(firstRegex: firstRegex, with: text, in: content)
        writeToFile(text: content)
    }
    
    func writeToFile(text: String?) {
        guard !dryRun else {
            console.info("writeToFile: \(text ?? "<nil>")")
            return
        }
        if fileExists() {
            removeFile()
        }
        createFile(content: text)
    }
    
    func readFile() -> String? {
        guard !dryRun else {
            console.info("readFile")
            return nil
        }
        return readString(encoding: .utf8)
    }
    
    func removeFile() {
        guard !dryRun else {
            console.info("removeFile")
            return
        }
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            fatalError("File removing error: \(error)")
        }
    }
    
    func fileExists() -> Bool {
        guard !dryRun else {
            console.info("fileExists")
            return false
        }
        return fileManager.fileExists(atPath: fileURL.path)
    }
    
    func copy(to: URL) {
        guard !dryRun else {
            console.info("copyTo: \(to.path)")
            return
        }
        do {
            if fileManager.fileExists(atPath: to.path) {
                try fileManager.removeItem(at: to)
            }
            try fileManager.copyItem(at: fileURL, to: to)
        } catch {
            fatalError("Error occured while copying file: \(error)")
        }
    }
}

// MARK: - Private
extension FileReader {
    private func replace(firstRegex: String, with newText: String, in content: String) -> String {
        guard let regexRange = content.range(of: firstRegex, options: .regularExpression) else { return content }
        var newContent = content
        newContent.removeSubrange(regexRange)
        newContent.insert(contentsOf: newText, at: regexRange.lowerBound)
        return newContent
    }
    
    private func createFile(content: String?) {
        fileManager.createFile(
            atPath: fileURL.path,
            contents: content?.data(using: .utf8))
    }
    
    private func readString(encoding: String.Encoding) -> String? {
        guard let data = readData() else { return nil }
        return String(data: data, encoding: encoding)
    }
    
    private func readData() -> Data? {
        fileManager.contents(atPath: fileURL.path)
    }
}
