import Foundation

public enum CardinalDirection: String, CustomStringConvertible {
    case north
    case northEast
    case east
    case southEast
    case south
    case southWest
    case west
    case northWest

    public init?(bearing: Double) {
        guard (0.0...360.0).contains(bearing) else { return nil }

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

    public var description: String {
        return rawValue
    }

    public var abbreviation: String {
        let characters = "NSEW".characters
        return String(description.characters.filter { characters.contains($0) })
    }
}

public extension CardinalDirection {
    var localizedDescription: String {
        return TroposCoreLocalizedString(description)
    }

    var localizedAbbreviation: String {
        return TroposCoreLocalizedString(abbreviation)
    }
}
