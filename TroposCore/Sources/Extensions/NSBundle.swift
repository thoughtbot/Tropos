import Foundation

extension NSBundle {
    static var troposBundle: NSBundle {
        return NSBundle(forClass: TroposBundleClass.self)
    }

    var versionNumber: String? {
        return objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
    }
}

private class TroposBundleClass: NSObject {}
