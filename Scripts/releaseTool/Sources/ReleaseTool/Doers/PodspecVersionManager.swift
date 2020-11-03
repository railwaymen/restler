import Foundation

final class PodspecVersionManager {
    private let manifest: Manifest
    private let gitRoot: URL
    private let executor: Executor
    private let dryRun: Bool
    
    // MARK: - Initialiation
    init(
        manifest: Manifest,
        gitRoot: URL,
        executor: Executor,
        dryRun: Bool
    ) {
        self.manifest = manifest
        self.gitRoot = gitRoot
        self.executor = executor
        self.dryRun = dryRun
    }
    
    // MARK: - Internal
    func updateVersions() {
        manifest.pods.forEach { pod in
            updateVersion(for: pod)
        }
    }
}

// MARK: - Private
extension PodspecVersionManager {
    private func updateVersion(for pod: Pod) {
        createPodspecBackup(pod: pod)
        changeVersionInPodspec(pod: pod)
    }
    
    private func createPodspecBackup(pod: Pod) {
        let fileURL = podspecURL(pod: pod)
        let backupFileURL = fileURL.appendingPathExtension("bak")
        getFileReader(fileURL: fileURL)
            .copy(to: backupFileURL)
    }
    
    private func changeVersionInPodspec(pod: Pod) {
        let reader = getFileReader(fileURL: podspecURL(pod: pod))
        reader.replace(
            firstRegex: ".version = '[0-9]+.*'",
            with: ".version = '\(manifest.versionString(of: pod))'")
    }
    
    private func getFileReader(fileURL: URL) -> FileReader {
        FileReader(
            fileURL: fileURL,
            dryRun: dryRun)
    }
    
    private func podspecURL(pod: Pod) -> URL {
        gitRoot.appendingPathComponent(pod.filename())
    }
}
