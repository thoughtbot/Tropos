import CoreLocation
import Nimble
import Quick
import ReactiveSwift
@testable import TroposCore

final class GeocodeControllerSpec: QuickSpec {
    override func spec() {
        describe("reverseGeocode") {
            it("sends the geocoded place and completes") {
                let geocoder = TestGeocoder(name: "test place")
                let controller = GeocodeController(geocoder: geocoder)
                let location = CLLocation(latitude: 1, longitude: 2)

                var isComplete = false
                var error: CLError?
                var place: CLPlacemark?

                controller.reverseGeocode(location).start { event in
                    switch event {
                    case let .value(value):
                        place = value
                    case let .failed(err):
                        error = err
                    case .completed:
                        isComplete = true
                    case .interrupted:
                        break
                    }
                }

                expect(isComplete).toEventually(beTrue())
                expect(place?.location?.coordinate).to(equal(location.coordinate))
                expect(place?.name).to(equal("test place"))
                expect(error).to(beNil())
            }

            it("passes through an error if it occurs") {
                let geocoder = TestGeocoder(error: .geocodeFoundNoResult)
                let controller = GeocodeController(geocoder: geocoder)
                let location = CLLocation(latitude: -1, longitude: -2)

                var error: CLError?
                controller.reverseGeocode(location).startWithFailed { error = $0 }

                expect(error).toEventuallyNot(beNil())
            }

            it("cancels the underlying geocode if the subscription is cancelled") {
                let geocoder = TestGeocoder(name: "test place")
                let controller = GeocodeController(geocoder: geocoder)
                let location = CLLocation(latitude: 3, longitude: 4)

                var value: CLPlacemark?
                var error: Error?
                var isCompleted = false
                var isInterrupted = false

                controller.reverseGeocode(location).start { event in
                    switch event {
                    case let .value(val):
                        value = val
                    case let .failed(err):
                        error = err
                    case .completed:
                        isCompleted = true
                    case .interrupted:
                        isInterrupted = true
                    }
                }

                geocoder.cancelGeocode()

                expect(isInterrupted).toEventually(beTrue())
                expect(isCompleted).to(beFalse())
                expect(error).to(beNil())
                expect(value).to(beNil())
            }
        }
    }
}
