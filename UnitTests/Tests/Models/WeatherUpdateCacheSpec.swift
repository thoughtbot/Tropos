@testable import Tropos
import Quick
import Nimble

private let testCacheFileName = "TestWeatherUpdate"

private var testCachesDirectory: NSURL {
    return NSFileManager.defaultManager()
        .URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        .first!
}

private var testWeatherUpdateURL: NSURL {
    return testCachesDirectory.URLByAppendingPathComponent(testCacheFileName)
}

private func resetFilesystem() {
    do {
        try NSFileManager.defaultManager().removeItemAtURL(testWeatherUpdateURL)
    } catch {}
}

final class WeatherUpdateCacheSpec: QuickSpec {
    override func spec() {
        describe("TRWeatherUpdateCache") {
            beforeEach(resetFilesystem)
            afterEach(resetFilesystem)

            context("-archiveLatestWeatherUpdate") {
                it("archives the object to disk") {
                    let cache = WeatherUpdateCache(fileName: testCacheFileName, inDirectory: testCachesDirectory)
                    let update = WeatherUpdate(placemark: testPlacemark, currentConditionsJSON: [:], yesterdaysConditionsJSON: [:])!

                    cache.archiveWeatherUpdate(update)

                    expect(NSFileManager.defaultManager().isReadableFileAtPath(testWeatherUpdateURL.path!)).to(beTrue())
                }
            }

            context("-latestWeatherUpdate") {
                it("returns nil when not archived") {
                    let cache = WeatherUpdateCache(fileName: testCacheFileName, inDirectory: testCachesDirectory)
                    expect(cache.latestWeatherUpdate).to(beNil())
                }

                it("returns an initialized TRWeatherUpdate when archive exists") {
                    let cache = WeatherUpdateCache(fileName: testCacheFileName, inDirectory: testCachesDirectory)
                    let update = WeatherUpdate(placemark: testPlacemark, currentConditionsJSON: [:], yesterdaysConditionsJSON: [:])!

                    let success = cache.archiveWeatherUpdate(update)

                    expect(success).to(beTruthy())
                    expect(cache.latestWeatherUpdate).to(beAKindOf(WeatherUpdate.self))
                }

                it("caches the date") {
                    let cache = WeatherUpdateCache(fileName: testCacheFileName, inDirectory: testCachesDirectory)
                    let date = NSDate(timeIntervalSince1970: 0)
                    let update = WeatherUpdate(placemark: testPlacemark, currentConditionsJSON: [:], yesterdaysConditionsJSON: [:], date: date)!

                    cache.archiveWeatherUpdate(update)

                    expect(cache.latestWeatherUpdate?.date) == date
                }
            }
        }
    }
}
