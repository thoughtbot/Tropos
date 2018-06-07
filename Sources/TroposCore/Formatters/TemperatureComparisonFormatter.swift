import Foundation

public struct TemperatureComparisonFormatter {
    public init() {}

    public func localizedStrings(
        fromComparison comparison: TemperatureComparison,
        precipitation: String,
        date: Date
    ) -> (description: String, adjective: String) {
        let adjective = comparison.localizedAdjective
        let timeOfDay = Calendar.current.localizedTimeOfDay(forDate: date)
        let timeOfYesterday = Calendar.current.localizedTimeOfYesterday(relativeToDate: date)

        let format = comparison == .same
            ? TroposCoreLocalizedString("SameTemperatureFormat")
            : TroposCoreLocalizedString("DifferentTemperatureFormat")

        return (
            description: String(format: format, adjective, timeOfDay, timeOfYesterday, precipitation),
            adjective: adjective
        )
    }
}
