import Foundation

@objc enum PrecipitationChance: Int {
    case None, Slight, Good
}

@objc class Precipitation: NSObject {
    let type: String
    let probability: Float
    
    var chance: PrecipitationChance {
        switch probability {
        case probability where probability > 30.0: return .Good
        case probability where probability > 0: return .Slight
        default: return .None
        }
    }
    
    init(probability: Float, type: String) {
        self.probability = probability
        self.type = type
    }
}