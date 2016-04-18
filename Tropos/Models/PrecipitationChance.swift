import Foundation

@objc(TRPrecipitationChance) enum PrecipitationChance: Int, CustomStringConvertible {
    case None, Slight, Good

    var description: String {
        switch self {
        case .Good:
            return "Good"
        case .Slight:
            return "Slight"
        case .None:
            return "None"
        }
    }

    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }
}
