import UIKit

extension UIFont {
    @objc public static func defaultLightFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "DINNextLTPro-Light", size: size)
    }

    @objc public static func defaultRegularFont(size: CGFloat) -> UIFont? {
        return UIFont(name: "DINNextLTPro-Regular", size: size)
    }
}
