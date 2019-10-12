public struct PreferencePage {
    public var preferenceSpecifiers: [PreferenceSpecifier]

    public init(preferenceSpecifiers: [PreferenceSpecifier] = []) {
        self.preferenceSpecifiers = preferenceSpecifiers
    }
}

extension PreferencePage: Codable {
    private enum CodingKeys: String, CodingKey {
        case preferenceSpecifiers = "PreferenceSpecifiers"
    }
}
