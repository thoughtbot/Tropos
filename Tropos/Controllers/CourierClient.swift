import Courier

@objc(TRCourierClient) final class CourierClient: NSObject {
    private let instance: Courier

    init(apiToken: String) {
        instance = Courier(apiToken: apiToken, environment: .Development)
    }

    func subscribeToChannel(channel: String, withToken token: NSData) {
        instance.subscribeToChannel(channel, withToken: token)
    }
}
