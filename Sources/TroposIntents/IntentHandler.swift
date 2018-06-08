import Intents
import TroposCore

final class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        guard intent is CheckWeatherIntent else {
            preconditionFailure("Unexpected intent type: \(intent)")
        }
        return CheckWeatherIntentHandler()
    }
}
