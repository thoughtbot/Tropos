import Courier

@objc(TRCourierClient) final class CourierClient: NSObject {
    private let instance: Courier

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
}
