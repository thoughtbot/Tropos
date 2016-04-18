enum CardinalDirection: String, CustomStringConvertible {
    case North
    case NorthEast
    case East
    case SouthEast
    case South
    case SouthWest
    case West
    case NorthWest

    init?(bearing: Double) {
        guard (0.0...360.0).contains(bearing) else { return nil }

        if bearing < 22.5 {
            self = .North
        } else if bearing < 67.5 {
            self = .NorthEast
        } else if bearing < 112.5 {
            self = .East
        } else if bearing < 157.5 {
            self = .SouthEast
        } else if bearing < 202.5 {
            self = .South
        } else if bearing < 247.5 {
            self = .SouthWest
        } else if bearing < 292.5 {
            self = .West
        } else if bearing < 337.5 {
            self = .NorthWest
        } else {
            self = .North
        }
    }

    var description: String {
        return rawValue
    }

    var abbreviation: String {
        let characters = "NSEW".characters
        return String(description.characters.filter { characters.contains($0) })
    }

    var localizedDescription: String {
        return NSLocalizedString(description, comment: "")
    }

    var localizedAbbreviation: String {
        return NSLocalizedString(abbreviation, comment: "")
    }
}
