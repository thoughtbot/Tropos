import Foundation

public enum PrecipitationChance: String, CustomStringConvertible {
    case None, Slight, Good

    public var description: String {
        return rawValue
    }

    public var localizedDescription: String {
        return TroposCoreLocalizedString(description)
    }
}
