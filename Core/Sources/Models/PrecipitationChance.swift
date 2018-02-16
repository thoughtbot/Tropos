import Foundation

public enum PrecipitationChance: String, CustomStringConvertible {
    case none, slight, good

    public var description: String {
        return rawValue
    }

    public var localizedDescription: String {
        return TroposCoreLocalizedString(description)
    }
}
