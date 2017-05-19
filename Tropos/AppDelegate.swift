import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow? = {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = ViewController()
    return window
  }()

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    window?.makeKeyAndVisible()
    return true
  }
}

