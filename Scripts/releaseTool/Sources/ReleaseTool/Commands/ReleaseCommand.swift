import ConsoleKit
import Foundation

final class ReleaseCommand: Command {
    
    struct Signature: CommandSignature {
        @Flag(
            name: "dry-run",
            help: "Prints all commands without calling them. Useful for testing.")
        var dryRun: Bool
        
        @Argument(
            name: "git-root",
            help: "A root directory of the project repository.")
        var gitRoot: String
        
        init() {}
    }
    
    var help: String {
        "A command to release the Restler framework to CocoaPods trunk."
    }
    
    func run(using context: CommandContext, signature: Signature) throws {
        let executor = Executor(dryRun: signature.dryRun)
        let gitRoot = URL(fileURLWithPath: signature.gitRoot)
        context.console.info(gitRoot.absoluteString)
        
        let manifest = Manifest.shared
        manifest.pods.filter(\.releasing).forEach { pod in
            let warningsOK = pod.allowWarnings ? "--allow-warnings" : ""
            let command: String = "pod trunk push --skip-tests --synchronous \(warningsOK) \(pod.name).podspec"
            executor.execute(command, workingDir: gitRoot)
        }
    }
}

struct PodspecVersionManager {
    let manifest: Manifest
    let gitRoot: URL
    
    func updateVersions() {
        
    }
}
