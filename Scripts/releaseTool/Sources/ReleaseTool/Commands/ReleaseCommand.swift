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
        context.console.info(gitRoot.path)
        let manifest = Manifest.shared
        
        context.console.info("Changing versions in podspecs...")
        PodspecVersionManager(
            manifest: manifest,
            gitRoot: gitRoot,
            executor: executor,
            dryRun: signature.dryRun)
            .updateVersions()
        
        context.console.info("Pushing pods to trunk...")
        PodspecPusher(
            manifest: manifest,
            executor: executor,
            gitRoot: gitRoot)
            .pushToTrunk()
    }
}
