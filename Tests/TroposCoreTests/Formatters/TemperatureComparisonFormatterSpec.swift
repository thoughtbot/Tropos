import Nimble
import Quick
import TroposCore

private func dateFromString(_ string: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zzz"
    return formatter.date(from: string)!
}

final class TemperatureComparisonFormatterSpec: QuickSpec {
    override func spec() {
        describe("TRTemperatureComparisonFormatter") {
            describe("localizedStringFromComparison:adjective:precipitation") {
                it("bases the time of day off of the date") {
                    let previousTimeZone = NSTimeZone.default
                    NSTimeZone.default = TimeZone(abbreviation: "UTC")!
                    defer { NSTimeZone.default = previousTimeZone }

                    let date = dateFromString("2015-05-15 22:00:00 UTC")
                    let (description, _) = TemperatureComparisonFormatter()
                        .localizedStrings(fromComparison: .same, precipitation: "", date: date)
                    expect(description) == "It's the same tonight as last night."
                }
            }
        }
    }
}
