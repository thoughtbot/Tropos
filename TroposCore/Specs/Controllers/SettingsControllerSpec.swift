import TroposCore
import Quick
import Nimble

final class SettingsControllerSpec: QuickSpec {
    override func spec() {
        describe("TRSettingsController") {
            describe("registered defaults") {
                beforeEach(resetUserDefaults)
                afterEach(resetUserDefaults)

                it("returns the correct value in an imperial locale") {
                    let controller = SettingsController(locale: NSLocale(localeIdentifier: "en_US"))
                    controller.registerSettings()
                    expect(controller.unitSystem) == UnitSystem.Imperial
                }

                it("returns the correct value in a metric locale") {
                    let controller = SettingsController(locale: NSLocale(localeIdentifier: "en_AU"))
                    controller.registerSettings()
                    expect(controller.unitSystem) == UnitSystem.Metric
                }
            }

            describe("migration") {
                it("converts from a string unit system representation to an integer") {
                    NSUserDefaults.standardUserDefaults().setObject("1", forKey: TRSettingsUnitSystemKey)
                    let controller = SettingsController()
                    expect(controller.unitSystem) == UnitSystem.Imperial
                }
            }
        }
    }
}

private func resetUserDefaults() {
    let defaults = NSUserDefaults.standardUserDefaults()

    defaults.dictionaryRepresentation()
        .keys
        .forEach(defaults.removeObjectForKey)
}
