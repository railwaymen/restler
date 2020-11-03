import Foundation

struct Pod {
    let name: String
    let isBeta: Bool
    let allowWarnings: Bool
    let podVersion: String?
    let releasing: Bool
    
    // MARK: - Initialization
    init(
        name: String,
        isBeta: Bool = false,
        allowWarnings: Bool = false,
        podVersion: String? = nil,
        releasing: Bool = true
    ) {
        self.name = name
        self.isBeta = isBeta
        self.allowWarnings = allowWarnings
        self.podVersion = podVersion
        self.releasing = releasing
    }
}
