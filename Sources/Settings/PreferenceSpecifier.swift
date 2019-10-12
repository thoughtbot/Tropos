public struct PreferenceSpecifier {
    public var file: String?
    public var footerText: String?
    public var title: String?
    public let type: String

    public init(type: String) {
        self.type = type
    }
}

extension PreferenceSpecifier: Codable {
    private enum CodingKeys: String, CodingKey {
        case file = "File"
        case footerText = "FooterText"
        case title = "Title"
        case type = "Type"
    }
}
