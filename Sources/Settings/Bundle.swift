import class Foundation.Bundle

extension Bundle {
    public var settingsBundle: Bundle? {
        return url(forResource: "Settings", withExtension: "bundle").flatMap {
            Bundle(url: $0)
        }
    }
}
