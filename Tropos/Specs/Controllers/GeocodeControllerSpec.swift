import Quick
import Nimble
@testable import Tropos

final class GeocodeControllerSpec: QuickSpec {
    override func spec() {
        describe("reverseGeocode") {
            it("sends the geocoded place and completes") {
                let geocoder = TestGeocoder(name: "test place")
                let controller = GeocodeController(geocoder: geocoder)
                let location = CLLocation(latitude: 1, longitude: 2)

                var isComplete = false
                var error: Error?
                var place: CLPlacemark?

                controller.reverseGeocodeLocation(location).subscribeNext({
                    place = $0
                }, error: {
                    error = $0
                }, completed: {
                    isComplete = true
                })

                expect(isComplete).toEventually(beTrue())
                expect(place?.location?.coordinate).to(equal(location.coordinate))
                expect(place?.name).to(equal("test place"))
                expect(error).to(beNil())
            }

            it("passes through an error if it occurs") {
                let geocoder = TestGeocoder(error: .geocodeFoundNoResult)
                let controller = GeocodeController(geocoder: geocoder)
                let location = CLLocation(latitude: -1, longitude: -2)

                var error: Error?
                controller.reverseGeocodeLocation(location).subscribeError { error = $0 }

                expect(error).toEventually(matchError(CLError.self))
            }

            it("cancels the underlying geocode if the subscription is cancelled") {
                let geocoder = TestGeocoder(name: "test place")
                let controller = GeocodeController(geocoder: geocoder)
                let location = CLLocation(latitude: 3, longitude: 4)

                var error: Error?
                var isCompleted = false
                controller.reverseGeocodeLocation(location).subscribeError({
                    error = $0
                }, completed: {
                    isCompleted = true
                })

                geocoder.cancelGeocode()
                RunLoop.current.run(until: Date().addingTimeInterval(0.1))

                expect(error).to(beNil())
                expect(isCompleted).to(beFalse())
            }
        }
    }
}
