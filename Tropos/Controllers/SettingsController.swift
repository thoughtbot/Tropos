import Foundation

@objc(TRSettingsController) final class SettingsController: NSObject {
    private let locale: NSLocale

    var unitSystem: UnitSystem {
        get {
            let rawUnitSystem = NSUserDefaults.standardUserDefaults().integerForKey(TRSettingsUnitSystemKey)
            return UnitSystem(rawValue: rawUnitSystem)!
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue.rawValue, forKey: TRSettingsUnitSystemKey)
        }
    }

    init(locale: NSLocale) {
        self.locale = locale
    }

    convenience override init() {
        self.init(locale: .autoupdatingCurrentLocale())
    }

    func registerSettings() {
        registerUnitSystem()
        registerLastVersion()
    }

    private func registerUnitSystem() {
        let localeUsesMetric = locale.objectForKey(NSLocaleUsesMetricSystem)?.boolValue ?? false
        let unitSystem: UnitSystem = localeUsesMetric ? .Metric : .Imperial
        NSUserDefaults.standardUserDefaults().registerDefaults([TRSettingsUnitSystemKey: unitSystem.rawValue])
    }

    private func registerLastVersion() {
        let version = NSBundle.mainBundle().versionNumber
        NSUserDefaults.standardUserDefaults().registerDefaults([TRSettingsLastVersionKey: version])
    }
}
