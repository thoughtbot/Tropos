import Foundation

@objc(TRSettingsController) public final class SettingsController: NSObject {
    private let locale: Locale
    private let userDefaults: UserDefaults

    public var unitSystem: UnitSystem {
        get {
            let rawUnitSystem = userDefaults.integer(forKey: TRSettingsUnitSystemKey)
            return UnitSystem(rawValue: rawUnitSystem)!
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: TRSettingsUnitSystemKey)
        }
    }

    public var unitSystemChanged: ((UnitSystem) -> Void)?

    @objc public init(locale: Locale, userDefaults: UserDefaults) {
        self.locale = locale
        self.userDefaults = userDefaults

        super.init()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(userDefaultsDidChange(_:)),
            name: UserDefaults.didChangeNotification,
            object: userDefaults
        )
    }

    @objc func userDefaultsDidChange(_ notification: Notification) {
        unitSystemChanged?(unitSystem)
    }

    @objc public convenience init(locale: Locale) {
        self.init(locale: locale, userDefaults: .standard)
    }

    public convenience override init() {
        self.init(locale: .autoupdatingCurrent)
    }

    @objc public func registerSettings() {
        registerUnitSystem()
        registerLastVersion()
    }

    private func registerUnitSystem() {
        let unitSystem: UnitSystem = locale.usesMetricSystem ? .metric : .imperial
        userDefaults.register(defaults: [TRSettingsUnitSystemKey: unitSystem.rawValue])
    }

    private func registerLastVersion() {
        if let version = Bundle.main.versionNumber {
            userDefaults.register(defaults: [TRSettingsLastVersionKey: version])
        }
    }
}
