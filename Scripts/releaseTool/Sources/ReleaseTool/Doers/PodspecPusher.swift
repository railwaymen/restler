import Foundation

final class PodspecPusher {
    private let manifest: Manifest
    private let executor: Executor
    private let gitRoot: URL
    
    // MARK: - Initialization
    init(
        manifest: Manifest,
        executor: Executor,
        gitRoot: URL
    ) {
        self.manifest = manifest
        self.executor = executor
        self.gitRoot = gitRoot
    }
    
    // MARK: - Internal
    func pushToTrunk() {
        manifest.pods.filter(\.releasing).forEach { pod in
            let warningsOK = pod.allowWarnings ? "--allow-warnings" : ""
            let command: String = "pod trunk push --skip-tests --synchronous \(warningsOK) \(pod.name).podspec"
            executor.execute(command, workingDir: gitRoot)
        }
    }
}
