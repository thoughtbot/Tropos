import TroposCore
import Quick
import Nimble

private let testCacheFileName = "TestWeatherUpdate"

private var testCachesDirectory: URL {
    return FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first!
}

private var testWeatherUpdateURL: URL {
    return testCachesDirectory.appendingPathComponent(testCacheFileName)
}

private func resetFilesystem() {
    do {
        try FileManager.default.removeItem(at: testWeatherUpdateURL)
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
                    let update = WeatherUpdate(
                        placemark: testPlacemark,
                        currentConditionsJSON: [:],
                        yesterdaysConditionsJSON: [:]
                    )!

                    cache.archiveWeatherUpdate(update)

                    expect(FileManager.default.isReadableFile(atPath: testWeatherUpdateURL.path)).to(beTrue())
                }
            }

            context("-latestWeatherUpdate") {
                it("returns nil when not archived") {
                    let cache = WeatherUpdateCache(fileName: testCacheFileName, inDirectory: testCachesDirectory)
                    expect(cache.latestWeatherUpdate).to(beNil())
                }

                it("returns an initialized TRWeatherUpdate when archive exists") {
                    let cache = WeatherUpdateCache(fileName: testCacheFileName, inDirectory: testCachesDirectory)
                    let update = WeatherUpdate(
                        placemark: testPlacemark,
                        currentConditionsJSON: [:],
                        yesterdaysConditionsJSON: [:]
                    )!

                    let success = cache.archiveWeatherUpdate(update)

                    expect(success).to(beTruthy())
                    expect(cache.latestWeatherUpdate).to(beAKindOf(WeatherUpdate.self))
                }

                it("caches the date") {
                    let cache = WeatherUpdateCache(fileName: testCacheFileName, inDirectory: testCachesDirectory)
                    let date = Date(timeIntervalSince1970: 0)
                    let update = WeatherUpdate(
                        placemark: testPlacemark,
                        currentConditionsJSON: [:],
                        yesterdaysConditionsJSON: [:],
                        date: date
                    )!

                    cache.archiveWeatherUpdate(update)

                    expect(cache.latestWeatherUpdate?.date) == date
                }
            }
        }
    }
}
