import HockeySDK
import TroposCore
import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    let applicationController = ApplicationController()
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]? = nil
    ) -> Bool {
        if isCurrentlyTesting {
            return true
        }

#if !DEBUG
        let hockeyManager = BITHockeyManager.shared()
        hockeyManager.configure(withIdentifier: TRHockeyIdentifier)
        hockeyManager.crashManager.crashManagerStatus = .autoSend
        hockeyManager.start()
        hockeyManager.authenticator.authenticateInstallation()

        AnalyticsController.shared.install()
#endif

        SettingsController().registerSettings()
        AppearanceController.configureAppearance()

        applicationController.setMinimumBackgroundFetchInterval(for: application)

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = applicationController.rootViewController
        window!.makeKeyAndVisible()

        applicationController.updateWeather()

        return true
    }

    func applicationWillEnterForeground(_: UIApplication) {
        applicationController.updateWeather()
    }

    func application(
        _: UIApplication,
        performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        applicationController.updateWeather().subscribeNext({ _ in
            completionHandler(.newData)
        }, error: { _ in
            completionHandler(.failed)
        })
    }
}

private extension AppDelegate {
    var isCurrentlyTesting: Bool {
        return UserDefaults.standard.bool(forKey: "TRTesting")
    }
}
