import Foundation

final class Executor {
    let dryRun: Bool
    
    // MARK: - Initialization
    init(dryRun: Bool) {
        self.dryRun = dryRun
    }
    
    // MARK: - Internal
    @discardableResult
    func execute(_ command: [String], workingDir: URL? = nil) -> Int32 {
        let command = command.joined(separator: " ")
        return execute(command, workingDir: workingDir)
    }
    
    @discardableResult
    func execute(_ command: String, workingDir: URL? = nil) -> Int32 {
        console.info(command)
        guard !self.dryRun else { return 0 }
        let task = createTask(forCommand: command, workingDir: workingDir)
        return run(task: task)
    }
}

// MARK: - Private
extension Executor {
    private func createTask(forCommand command: String, workingDir: URL?) -> Process {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        task.arguments = command.split(separator: " ").map { String($0) }
        if let workingDir = workingDir {
            task.currentDirectoryURL = workingDir
            task.currentDirectoryPath = workingDir.path
        }
        return task
    }
    
    private func run(task: Process) -> Int32 {
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus
    }
}

