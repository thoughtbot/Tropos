import Foundation

@objc(TRSettingsController) public final class SettingsController: NSObject {
    private let locale: NSLocale
    private let userDefaults: NSUserDefaults

    public var unitSystem: UnitSystem {
        get {
            let rawUnitSystem = userDefaults.integerForKey(TRSettingsUnitSystemKey)
            return UnitSystem(rawValue: rawUnitSystem)!
        }
        set {
            userDefaults.setInteger(newValue.rawValue, forKey: TRSettingsUnitSystemKey)
        }
    }

    public var unitSystemChanged: ((UnitSystem) -> Void)?

    public init(locale: NSLocale, userDefaults: NSUserDefaults) {
        self.locale = locale
        self.userDefaults = userDefaults

        super.init()

        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(userDefaultsDidChange(_:)),
            name: NSUserDefaultsDidChangeNotification,
            object: userDefaults)
    }

    func userDefaultsDidChange(notification: NSNotification) {
        unitSystemChanged?(unitSystem)
    }

    public convenience init(locale: NSLocale) {
        self.init(locale: locale, userDefaults: .standardUserDefaults())
    }

    public convenience override init() {
        self.init(locale: .autoupdatingCurrentLocale())
    }

    public func registerSettings() {
        registerUnitSystem()
        registerLastVersion()
    }

    private func registerUnitSystem() {
        let localeUsesMetric = locale.objectForKey(NSLocaleUsesMetricSystem)?.boolValue ?? false
        let unitSystem: UnitSystem = localeUsesMetric ? .Metric : .Imperial
        userDefaults.registerDefaults([TRSettingsUnitSystemKey: unitSystem.rawValue])
    }

    private func registerLastVersion() {
        if let version = NSBundle.mainBundle().versionNumber {
            userDefaults.registerDefaults([TRSettingsLastVersionKey: version])
        }
    }
}
