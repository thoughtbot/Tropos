import Foundation

extension NSBundle {
    @objc var versionNumber: String {
        return objectForInfoDictionaryKey(kCFBundleVersionKey as String) as! String
    }
}
