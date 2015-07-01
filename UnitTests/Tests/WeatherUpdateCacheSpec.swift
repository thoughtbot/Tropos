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
    
    func weatherConditions(temperature: Int) -> Dictionary<String, AnyObject> {
        let dailyValue = ["time": 50, "icon": "some-icon", "temperatureMin": 50, "temperatureMax": 60]
        let dailyData = [dailyValue, dailyValue, dailyValue, dailyValue]
        return ["currently": ["temperature": temperature], "daily": ["data": dailyData]]
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
                    let conditions = self.weatherConditions(30)
                    let update = TRWeatherUpdate(placemark: self.placemark(), currentConditionsJSON: conditions, yesterdaysConditionsJSON: NSDictionary())
                    
                    expect(WeatherUpdateCacheMock.archive(update)).to(equal(true))
                    expect(NSFileManager.defaultManager().isReadableFileAtPath(WeatherUpdateCacheSpec.weatherUpdateURLForTesting().path!)).to(equal(true))
                }
            }

            context("latest weather update") {
                it("returns nil when not archived") {
                    expect(WeatherUpdateCacheMock.latestWeatherUpdate()).to(beNil())
                }
                
                it("returns weather update when archive exists") {
                    let conditions = self.weatherConditions(30)
                    let update = TRWeatherUpdate(placemark: self.placemark(), currentConditionsJSON: conditions, yesterdaysConditionsJSON: NSDictionary())
                    WeatherUpdateCacheMock.archive(update)
                    
                    expect(WeatherUpdateCacheMock.latestWeatherUpdate()).to(beAnInstanceOf(TRWeatherUpdate))
                }
                
                it("caches the date") {
                    let conditions = self.weatherConditions(30)
                    let date = NSDate()
                    let update = TRWeatherUpdate(placemark: self.placemark(), currentConditionsJSON: conditions, yesterdaysConditionsJSON: Dictionary<NSObject, AnyObject>(), date: date)
                    WeatherUpdateCacheMock.archive(update)
                    
                    expect(WeatherUpdateCacheMock.latestWeatherUpdate()?.date).to(equal(date))
                }
            }
        }
    }
}