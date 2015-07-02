import Foundation
import Quick
import Nimble
import MapKit
import AddressBook

class WeatherUpdateSpec: QuickSpec {
    
    func placemark() -> CLPlacemark {
        return MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20), addressDictionary: ["City": "Palo Alto", kABPersonAddressStateKey: "CA"])
    }
    
    override func spec() {
        describe("WeatherUpdate") {
            it("should be correctly created and filled") {
                let weatherConditions = WeatherConditions(currentConditionsJSON: CurrentConditionsSpec.currentConditionsJSON(), yesterdaysConditionsJSON: WeatherConditionsSpec.yesterdaysConditionsJSON())
                let weatherUpdate = WeatherUpdate(placemark: self.placemark(), weatherConditions: weatherConditions)
                expect(weatherUpdate.date).toNot(beNil())
                expect(weatherUpdate.placemark).toNot(beNil())
            }
        }
    }
}