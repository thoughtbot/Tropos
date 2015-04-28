@objc final class AppearanceManager {
  static func configureAppearance() {
    UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont.defaultUltraLightFontOfSize(20), NSForegroundColorAttributeName: UIColor.lightTextColor()]
    
    let attributes = [NSFontAttributeName: UIFont.defaultUltraLightFontOfSize(16), NSForegroundColorAttributeName: UIColor.lightTextColor()]
    UIBarButtonItem.appearance().setTitleTextAttributes(attributes, forState: .Normal)
  }
}
