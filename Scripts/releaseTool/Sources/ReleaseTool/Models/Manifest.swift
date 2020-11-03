import Foundation

struct Manifest {
    let version: String
    let pods: [Pod]
    
    // MARK: - Internal
    func versionString(of pod: Pod) -> String {
        let finalVersion: String
        if let betaNumber = pod.betaNumber {
            finalVersion = version + "-beta.\(betaNumber)"
        } else {
            finalVersion = version
        }
        return pod.podVersion ?? finalVersion
    }
}

// MARK: - Shared
extension Manifest {
    static let shared = Manifest(
        version: "1.0.1",
        pods: [
            Pod(name: "RestlerCore"),
            Pod(name: "RxRestler"),
            Pod(name: "Restler"),
        ])
}
