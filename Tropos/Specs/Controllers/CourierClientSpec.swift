import Quick
import Nimble
@testable import Tropos

class CourierClientSpec: QuickSpec {
    override func spec() {
        describe("channelNameForTimeZone") {
            it("returns plus 0200 for +7200 seconds from GMT") {
                let timeZone = FakeTimeZone(secondsFromGMT: 7200)

                let channel = CourierClient.channelNameForTimeZone(timeZone)

                expect(channel) == "plus 0200"
            }

            it("returns minus 0700 for -25200 seconds from GMT") {
                let timeZone = FakeTimeZone(secondsFromGMT: -25200)

                let channel = CourierClient.channelNameForTimeZone(timeZone)

                expect(channel) == "minus 0700"
            }

            it("returns plus 0230 for +9000 seconds from GMT") {

                let timeZone = FakeTimeZone(secondsFromGMT: 9000)

                let channel = CourierClient.channelNameForTimeZone(timeZone)

                expect(channel) == "plus 0230"
            }
        }
    }
}

@objc class FakeTimeZone: NSObject, TimeZone {
    var secondsFromGMT: Int

    init(secondsFromGMT: Int) {
        self.secondsFromGMT = secondsFromGMT
    }
}
