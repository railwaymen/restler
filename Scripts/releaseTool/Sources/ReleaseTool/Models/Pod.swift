import Foundation

struct Pod {
    let name: String
    let betaNumber: Int?
    let allowWarnings: Bool
    let podVersion: String?
    let releasing: Bool
    
    // MARK: - Initialization
    init(
        name: String,
        betaNumber: Int? = nil,
        allowWarnings: Bool = false,
        podVersion: String? = nil,
        releasing: Bool = true
    ) {
        self.name = name
        self.betaNumber = betaNumber
        self.allowWarnings = allowWarnings
        self.podVersion = podVersion
        self.releasing = releasing
    }
    
    // MARK: - Internal
    func filename() -> String {
        name + ".podspec"
    }
}
