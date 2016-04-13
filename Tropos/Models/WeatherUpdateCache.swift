import Foundation

private let TRLatestWeatherUpdateFileName = "TRLatestWeatherUpdateFile"

@objc(TRWeatherUpdateCache) class WeatherUpdateCache: NSObject {
    let cachePath: String

    init(fileName: String, inDirectory directory: NSURL) {
        let url = directory.URLByAppendingPathComponent(fileName)
        guard let path = url.path else {
            fatalError("not a valid path: \(url)")
        }
        cachePath = path
    }

    convenience init(fileName: String) {
        let fileManager = NSFileManager.defaultManager()
        guard let cachesURL = fileManager.URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first else {
            fatalError("Unable to locate user caches directory")
        }
        self.init(fileName: fileName, inDirectory: cachesURL)
    }

    convenience override init() {
        self.init(fileName: TRLatestWeatherUpdateFileName)
    }

    var latestWeatherUpdate: WeatherUpdate? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(cachePath) as? WeatherUpdate
    }

    func archiveWeatherUpdate(weatherUpdate: WeatherUpdate) -> Bool {
        return NSKeyedArchiver.archiveRootObject(weatherUpdate, toFile: cachePath)
    }
}
