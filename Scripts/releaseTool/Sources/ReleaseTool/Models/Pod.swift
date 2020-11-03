import Foundation

struct Pod {
    let name: String
    let betaNumber: Int?
    let allowWarnings: Bool
    let releasing: Bool
    
    // MARK: - Initialization
    init(
        name: String,
        betaNumber: Int? = nil,
        allowWarnings: Bool = false,
        releasing: Bool = true
    ) {
        self.name = name
        self.betaNumber = betaNumber
        self.allowWarnings = allowWarnings
        self.releasing = releasing
    }
    
    // MARK: - Internal
    func filename() -> String {
        name + ".podspec"
    }
}
