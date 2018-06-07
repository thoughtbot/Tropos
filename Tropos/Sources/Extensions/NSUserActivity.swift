import Intents

extension NSUserActivity {
    @objc(tr_checkWeatherUserActivity)
    static var checkWeather: NSUserActivity {
        let activity = NSUserActivity(activityType: "com.thoughtbot.carlweathers.CheckWeatherActivity")

        activity.isEligibleForSearch = true
        activity.title = checkWeatherTitle

        if #available(iOS 12, *) {
            activity.isEligibleForPrediction = true
            activity.suggestedInvocationPhrase = checkWeatherSuggestedPhrase
        }

        return activity
    }

    private static let checkWeatherSuggestedPhrase = NSLocalizedString(
        "Check the weather",
        comment: "Siri suggestion phrase to check weather")

    private static let checkWeatherTitle = NSLocalizedString(
        "Check weather forecast",
        comment: "Title for check weather activity")
}
