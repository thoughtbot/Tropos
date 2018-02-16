import Foundation

struct PrecipitationChanceFormatter {
    func localizedStringFromPrecipitation(_ precipitation: Precipitation) -> String {
        let adjective = precipitation.chance.description.capitalized
        let type = precipitation.type.capitalized
        return TroposCoreLocalizedString(adjective + type)
    }
}
