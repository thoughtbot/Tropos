import Intents
import TroposCore

@available(iOS 12.0, *)
extension INInteraction {
    @objc(tr_checkWeatherInteraction)
    static var checkWeather: INInteraction {
        let intent = CheckWeatherIntent()
        intent.suggestedInvocationPhrase = checkWeatherSuggestedPhrase
        return INInteraction(intent: intent, response: nil)
    }

    private static let checkWeatherSuggestedPhrase = NSLocalizedString(
        "Check the weather",
        comment: "Siri suggestion phrase to check weather")
}
