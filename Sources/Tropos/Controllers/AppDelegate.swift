import AppCenter
import AppCenterCrashes
import os.log
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

        assertValidSecrets()
        setupAnalytics()
        setupCrashReporting()
        SettingsController().registerSettings()
        AppearanceController.configureAppearance()
        applicationController.setMinimumBackgroundFetchInterval(for: application)

        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = applicationController.rootViewController
        window!.makeKeyAndVisible()

        return true
    }

    func applicationDidBecomeActive(_: UIApplication) {
        applicationController.updateWeather().subscribeError(weatherUpdateFailed)
    }

    func application(
        _: UIApplication,
        performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        applicationController.updateWeather().subscribeNext({ _ in
            completionHandler(.newData)
        }, error: {
            weatherUpdateFailed(with: $0)
            completionHandler(.failed)
        })
    }
}

private func weatherUpdateFailed(with error: Error!) {
    if #available(iOS 10.0, *) {
        os_log("Failed to update weather: %{public}@", type: .error, error.localizedDescription)
    } else {
        NSLog("Failed to update weather: %@", error.localizedDescription)
    }
}

private extension AppDelegate {
    var isCurrentlyTesting: Bool {
        return UserDefaults.standard.bool(forKey: "TRTesting")
    }

    func assertValidSecrets() {
        assert(!TRAppCenterSecret.isEmpty, "App Center identifier not set")
        assert(!TRForecastAPIKey.isEmpty, "Forecast API key not set")
        assert(!TRMixpanelToken.isEmpty, "Mixpanel token not set")
    }

    func setupAnalytics() {
#if !DEBUG
        AnalyticsController.shared.install()
#endif
    }

    func setupCrashReporting() {
#if !DEBUG
        MSAppCenter.start(TRAppCenterSecret, withServices: [MSCrashes.self])
#endif
    }
}
