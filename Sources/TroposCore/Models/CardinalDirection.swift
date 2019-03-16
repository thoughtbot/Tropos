import Foundation

public enum CardinalDirection: String {
    case north = "North"
    case northEast = "NorthEast"
    case east = "East"
    case southEast = "SouthEast"
    case south = "South"
    case southWest = "SouthWest"
    case west = "West"
    case northWest = "NorthWest"

    public init?(bearing: Double) {
        guard (0.0 ... 360.0).contains(bearing) else { return nil }

        if bearing < 22.5 {
            self = .north
        } else if bearing < 67.5 {
            self = .northEast
        } else if bearing < 112.5 {
            self = .east
        } else if bearing < 157.5 {
            self = .southEast
        } else if bearing < 202.5 {
            self = .south
        } else if bearing < 247.5 {
            self = .southWest
        } else if bearing < 292.5 {
            self = .west
        } else if bearing < 337.5 {
            self = .northWest
        } else {
            self = .north
        }
    }

    public var abbreviation: String {
        return rawValue.filter { "NSEW".contains($0) }
    }
}

public extension CardinalDirection {
    var localizedDescription: String {
        return TroposCoreLocalizedString(rawValue.capitalized)
    }

    var localizedAbbreviation: String {
        return TroposCoreLocalizedString(abbreviation)
    }
}
