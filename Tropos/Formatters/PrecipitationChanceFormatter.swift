import Foundation
import TroposCore

struct PrecipitationChanceFormatter {
    func localizedStringFromPrecipitation(precipitation: Precipitation) -> String {
        let adjective = precipitation.chance.description
        let type = precipitation.type.capitalizedString
        return NSLocalizedString(adjective + type, comment: "")
    }
}
