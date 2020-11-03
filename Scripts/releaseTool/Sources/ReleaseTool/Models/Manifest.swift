import Foundation

struct Manifest {
    let version: String
    let pods: [Pod]
    
    // MARK: - Internal
    func versionString(of pod: Pod) -> String {
        pod.podVersion ?? (pod.isBeta ? version + "-beta" : version)
    }
}

// MARK: - Shared
extension Manifest {
    static let shared = Manifest(
        version: "1.0.1",
        pods: [
            Pod(name: "RestlerCore"),
            Pod(name: "RxRestler"),
            Pod(name: "Restler", isBeta: true),
        ])
}
