import Intents

@available(iOS 12.0, *)
extension INInteraction {
    @objc(tr_checkWeatherInteraction)
    static var checkWeather: INInteraction {
        let intent = CheckWeatherIntent()
        intent.suggestedInvocationPhrase = checkWeatherSuggestedPhrase
        return INInteraction(intent: intent, response: nil)
    }

    private static let checkWeatherSuggestedPhrase = NSString
        .deferredLocalizedIntentsString(with: "CheckWeatherSuggestedPhrase") as String
}
