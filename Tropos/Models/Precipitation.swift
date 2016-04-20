import Foundation

struct Precipitation {
    var probability: Double
    var type: String

    var chance: PrecipitationChance {
        switch probability {
        case _ where probability > 0.3: return .Good
        case _ where probability > 0: return .Slight
        default: return .None
        }
    }
}
