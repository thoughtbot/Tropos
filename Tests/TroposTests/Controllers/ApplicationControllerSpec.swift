import Nimble
import Quick
import UIKit

final class ApplicationControllerSpec: QuickSpec {
    override func spec() {
        describe("setMinimimBackgroundFetchIntervalForApplication") {
            it("sets the interval to minimum when authorization is always") {
                let application = TestApplication()
                let locationController = TestLocationController()
                locationController.authorizationStatus = .authorizedAlways
                let controller = ApplicationController(locationController: locationController)

                var interval: TimeInterval?
                application.didSetMinimumBackgroundFetchInterval = { interval = $0 }
                controller.setMinimumBackgroundFetchInterval(for: application)

                expect(interval).to(equal(UIApplicationBackgroundFetchIntervalMinimum))
            }

            it("sets the interval to never when authorization is not always") {
                let application = TestApplication()
                let locationController = TestLocationController()
                locationController.authorizationStatus = .authorizedWhenInUse
                let controller = ApplicationController(locationController: locationController)

                var interval: TimeInterval?
                application.didSetMinimumBackgroundFetchInterval = { interval = $0 }
                controller.setMinimumBackgroundFetchInterval(for: application)

                expect(interval).to(equal(UIApplicationBackgroundFetchIntervalNever))
            }
        }
    }
}
