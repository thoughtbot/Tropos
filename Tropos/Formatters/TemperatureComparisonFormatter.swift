import Foundation

@objc(TRTemperatureComparisonFormatter) class TemperatureComparisonFormatter: NSObject {
    static func localizedStrings(fromComparison comparison: TemperatureComparison, precipitation: String, date: NSDate) -> (description: String, adjective: String) {
        let adjective = comparison.localizedAdjective
        let timeOfDay = NSCalendar.currentCalendar().localizedTimeOfDay(forDate: date)
        let timeOfYesterday = NSCalendar.currentCalendar().localizedTimeOfYesterday(relativeToDate: date)

        let format = comparison == .Same
            ? NSLocalizedString("SameTemperatureFormat", comment: "")
            : NSLocalizedString("DifferentTemperatureFormat", comment: "")

        return (
            description: String(format: format, adjective, timeOfDay, timeOfYesterday, precipitation),
            adjective: adjective
        )
    }

    @available(*, unavailable, message="use localizedStrings(fromComparison:precipitation:date:) instead")
    static func localizedStringFromComparison(comparison: TemperatureComparison, adjective: UnsafeMutablePointer<NSString?>, precipitation: String, date: NSDate) -> String {
        let result = localizedStrings(fromComparison: comparison, precipitation: precipitation, date: date)
        if adjective != nil {
            adjective.memory = result.adjective
        }
        return result.description
    }
}
