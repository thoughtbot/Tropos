public struct Precipitation {
    public var probability: Double
    public var type: String

    public init(probability: Double, type: String) {
        self.probability = probability
        self.type = type
    }

    public var chance: PrecipitationChance {
        switch probability {
        case _ where probability > 0.3: return .Good
        case _ where probability > 0: return .Slight
        default: return .None
        }
    }
}
