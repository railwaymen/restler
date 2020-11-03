import ConsoleKit
import Foundation

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: false)
commands.use(ReleaseCommand(), as: "release", isDefault: false)

do {
    let group = commands.group(help: "A tool for releasing the Restler framework to CocoaPods repo.")
    try console.run(group, input: input)
} catch {
    console.error("\(error)")
    exit(1)
}
