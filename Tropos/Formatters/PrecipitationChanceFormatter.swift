import Foundation

@objc(TRPrecipitationChanceFormatter) final class PrecipitationChanceFormatter: NSObject {
    func localizedStringFromPrecipitation(precipitation: Precipitation) -> String {
        let adjective = precipitation.chance.description
        let type = precipitation.type.capitalizedString
        return NSLocalizedString(adjective + type, comment: "")
    }
}
