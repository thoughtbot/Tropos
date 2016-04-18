import Foundation

enum PrecipitationChance: String, CustomStringConvertible {
    case None, Slight, Good

    var description: String {
        return rawValue
    }

    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}
