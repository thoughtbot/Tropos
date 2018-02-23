import Foundation

extension UserDefaults {
    static func makeRandomDefaults() -> UserDefaults {
        return UserDefaults(suiteName: UUID().description)!
    }
}
