import Foundation

struct Manifest {
    let version: String
    let pods: [Pod]
    
    // MARK: - Internal
    func versionString(of pod: Pod) -> String {
        var finalVersion: String = version
        if let betaNumber = pod.betaNumber {
            finalVersion.append("-beta.\(betaNumber)")
        }
        return finalVersion
    }
}

// MARK: - Shared
extension Manifest {
    static let shared = Manifest(
        version: "1.1.1",
        pods: [
            Pod(name: "RestlerCore"),
            Pod(name: "RxRestler"),
            Pod(name: "RestlerCombine"),
            Pod(name: "Restler"),
        ])
}
