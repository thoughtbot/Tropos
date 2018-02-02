import Foundation

extension Bundle {
    static var troposBundle: Bundle {
        return Bundle(for: TroposBundleClass.self)
    }

    var versionNumber: String? {
        return object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}

private class TroposBundleClass: NSObject {}
