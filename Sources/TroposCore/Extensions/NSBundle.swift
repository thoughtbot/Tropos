import Foundation

extension Bundle {
    @objc static var troposBundle: Bundle {
        return Bundle(for: TroposBundleClass.self)
    }

    @objc var versionNumber: String? {
        return object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
    }
}

private class TroposBundleClass: NSObject {}
