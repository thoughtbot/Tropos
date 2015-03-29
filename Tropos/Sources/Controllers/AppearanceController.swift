import UIKit
import TroposCore

@objc(TRAppearanceController) final class AppearanceController: NSObject {
    static func configureAppearance() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = [
            NSFontAttributeName: UIFont.defaultLightFont(size: 20),
            NSForegroundColorAttributeName: UIColor.lighterTextColor
        ]
        navigationBar.tintColor = .lighterTextColor

        let attributes = [
            NSFontAttributeName: UIFont.defaultLightFont(size: 17),
            NSForegroundColorAttributeName: UIColor.lighterTextColor
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
    }
}
