import Foundation

@available(iOS 12.0, *)
public final class CheckWeatherIntentHandler: NSObject, CheckWeatherIntentHandling {
    public func handle(intent: CheckWeatherIntent, completion: @escaping (CheckWeatherIntentResponse) -> Void) {
        let response = CheckWeatherIntentResponse.success(conditionsDescription: "Hello, Tropos!")
        completion(response)
    }
}
