import Foundation

@objc(TRPrecipitation) class Precipitation: NSObject {
    let type: String
    let probability: Float

    var chance: PrecipitationChance {
        switch probability {
        case _ where probability > 0.3: return .Good
        case _ where probability > 0: return .Slight
        default: return .None
        }
    }

    init(probability: Float, type: String) {
        self.probability = probability
        self.type = type
    }
}
