import TroposCore
import UIKit

@objc(TRAppearanceController) final class AppearanceController: NSObject {
    @objc static func configureAppearance() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.titleTextAttributes = [
            .font: UIFont.defaultLightFont(size: 20)!,
            .foregroundColor: UIColor.lighterTextColor,
        ]
        navigationBar.tintColor = .lighterTextColor

        let attributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.defaultLightFont(size: 17)!,
            .foregroundColor: UIColor.lighterTextColor,
        ]
        UIBarButtonItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }
}
