@objc final class AppearanceManager {
  static func configureAppearance() {
    let navigationBar = UINavigationBar.appearance()
    navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.defaultLightFontOfSize(20), NSForegroundColorAttributeName: UIColor.lightTextColor()]
    navigationBar.tintColor = .lightTextColor()

    let attributes = [NSFontAttributeName: UIFont.defaultLightFontOfSize(17), NSForegroundColorAttributeName: UIColor.lightTextColor()]
    UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
  }
}
