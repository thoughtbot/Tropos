import Foundation

extension NSBundle {
    static var troposBundle: NSBundle {
        return NSBundle(forClass: TroposBundleClass.self)
    }
}

private class TroposBundleClass: NSObject {}
