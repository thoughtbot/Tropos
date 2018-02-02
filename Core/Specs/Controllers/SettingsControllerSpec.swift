import TroposCore
import Quick
import Nimble

final class SettingsControllerSpec: QuickSpec {
    override func spec() {
        describe("TRSettingsController") {
            describe("registered defaults") {
                beforeEach(resetUserDefaults)
                afterEach(resetUserDefaults)

                fit("returns the correct value in an imperial locale") {
                    let controller = SettingsController(locale: Locale(identifier: "en_US"))
                    controller.registerSettings()
                    expect(controller.unitSystem) == UnitSystem.imperial
                }

                it("returns the correct value in a metric locale") {
                    let controller = SettingsController(locale: Locale(identifier: "en_AU"))
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

private func resetUserDefaults() {
    let defaults = UserDefaults.standard

    defaults.dictionaryRepresentation()
        .keys
        .forEach(defaults.removeObject)
}
