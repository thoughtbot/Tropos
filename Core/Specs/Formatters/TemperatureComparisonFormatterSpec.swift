import TroposCore
import Quick
import Nimble

private func dateFromString(string: String) -> NSDate {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
    return formatter.dateFromString(string)!
}

final class TemperatureComparisonFormatterSpec: QuickSpec {
    override func spec() {
        describe("TRTemperatureComparisonFormatter") {
            describe("localizedStringFromComparison:adjective:precipitation") {
                it("bases the time of day off of the date") {
                    let previousTimeZone = NSCalendar.currentCalendar().timeZone
                    NSCalendar.currentCalendar().timeZone = NSTimeZone(abbreviation: "UTC")!
                    defer { NSCalendar.currentCalendar().timeZone = previousTimeZone }

                    let date = dateFromString("2015-05-15 22:00:00 UTC")
                    let (description, _) = TemperatureComparisonFormatter().localizedStrings(fromComparison: .Same, precipitation: "", date: date)
                    expect(description) == "It's the same tonight as last night."
                }
            }
        }
    }
}
