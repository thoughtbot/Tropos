import Courier

@objc protocol TimeZone {
    var secondsFromGMT: Int { get }
}
extension NSTimeZone: TimeZone {}

@objc(TRCourierClient) final class CourierClient: NSObject {
    private let instance: Courier

    class func channelNameForTimeZone(timeZone: TimeZone) -> String {
        let seconds = timeZone.secondsFromGMT
        let sign = seconds < 0 ? "minus" : "plus"
        let hours = abs(seconds) / 3600
        let minutes = (abs(seconds) % 3600) / 60
        return String(format: "%@ %02d%02d", sign, hours, minutes)
    }

    init(apiToken: String) {
        let environment: Environment

        #if DEBUG
            environment = .Development
        #else
            environment = .Production
        #endif

        instance = Courier(apiToken: apiToken, environment: environment)
    }

    func subscribeToChannel(channel: String, withToken token: NSData) {
        instance.subscribeToChannel(channel, withToken: token)
    }

    func unsubscribeFromChannel(channel: String) {
        instance.unsubscribeFromChannel(channel)
    }
}
