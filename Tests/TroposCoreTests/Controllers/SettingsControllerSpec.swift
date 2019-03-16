import Nimble
import Quick
import TroposCore

final class SettingsControllerSpec: QuickSpec {
    override func spec() {
        describe("TRSettingsController") {
            describe("registered defaults") {
                it("returns the correct value in an imperial locale") {
                    let defaults = UserDefaults.makeRandomDefaults()
                    let controller = SettingsController(locale: Locale(identifier: "en_US"), userDefaults: defaults)
                    controller.registerSettings()
                    expect(controller.unitSystem) == UnitSystem.imperial
                }

                it("returns the correct value in a metric locale") {
                    let defaults = UserDefaults.makeRandomDefaults()
                    let controller = SettingsController(locale: Locale(identifier: "en_AU"), userDefaults: defaults)
                    controller.registerSettings()
                    expect(controller.unitSystem) == UnitSystem.metric
                }
            }

            describe("migration") {
                it("converts from a string unit system representation to an integer") {
                    UserDefaults.standard.set("1", forKey: TRSettingsUnitSystemKey)
                    let controller = SettingsController()
                    expect(controller.unitSystem) == UnitSystem.imperial
                }
            }
        }
    }
}
