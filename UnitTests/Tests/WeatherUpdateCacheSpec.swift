import Foundation
import Quick
import Nimble
import CoreLocation
import AddressBook
import MapKit

@objc class WeatherUpdateCacheMock: WeatherUpdateCache {
    override class func latestWeatherUpdateFilePath() -> String? {
        return WeatherUpdateCacheSpec.weatherUpdateURLForTesting().path
    }
}

class WeatherUpdateCacheSpec: QuickSpec {
    
    class func weatherUpdateURLForTesting() -> NSURL {
        let url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        return url.URLByAppendingPathComponent("TestWeatherUpdate")
    }
    
    func placemark() -> CLPlacemark {
        return MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20), addressDictionary: ["City": "Palo Alto", kABPersonAddressStateKey: "CA"])
    }
    
    func resetFileSystem() {
        NSFileManager.defaultManager().removeItemAtURL(WeatherUpdateCacheSpec.weatherUpdateURLForTesting(), error: nil)
    }
    
    override func spec() {
        beforeEach () {
            self.resetFileSystem()
        }
        
        describe("WeatherUpdateCache") {
            context("archiving") {
                it("archives the object to disk") {
                    let conditions = WeatherConditions(currentConditionsJSON: CurrentConditionsSpec.currentConditionsJSON(currentTemp: 30), yesterdaysConditionsJSON: WeatherConditionsSpec.yesterdaysConditionsJSON())
                    let weatherUpdate = WeatherUpdate(placemark: self.placemark(), weatherConditions: conditions)
                    
                    expect(WeatherUpdateCacheMock.archive(weatherUpdate)).to(equal(true))
                    expect(NSFileManager.defaultManager().isReadableFileAtPath(WeatherUpdateCacheSpec.weatherUpdateURLForTesting().path!)).to(equal(true))
                }
            }

            context("latest weather update") {
                it("returns nil when not archived") {
                    expect(WeatherUpdateCacheMock.latestWeatherUpdate()).to(beNil())
                }
                
                it("returns weather update when archive exists") {
                    let conditions = WeatherConditions(currentConditionsJSON: CurrentConditionsSpec.currentConditionsJSON(currentTemp: 30), yesterdaysConditionsJSON: WeatherConditionsSpec.yesterdaysConditionsJSON())
                    let weatherUpdate = WeatherUpdate(placemark: self.placemark(), weatherConditions: conditions)
                    WeatherUpdateCacheMock.archive(weatherUpdate)
                    
                    expect(WeatherUpdateCacheMock.latestWeatherUpdate()).to(beAnInstanceOf(WeatherUpdate))
                }
                
                it("caches the date") {
                    let date = NSDate()
                    let conditions = WeatherConditions(currentConditionsJSON: CurrentConditionsSpec.currentConditionsJSON(currentTemp: 30), yesterdaysConditionsJSON: WeatherConditionsSpec.yesterdaysConditionsJSON())
                    let weatherUpdate = WeatherUpdate(placemark: self.placemark(), weatherConditions: conditions, date: date)

                    WeatherUpdateCacheMock.archive(weatherUpdate)
                    expect(WeatherUpdateCacheMock.latestWeatherUpdate()?.date).to(equal(date))
                }
            }
        }
    }
}