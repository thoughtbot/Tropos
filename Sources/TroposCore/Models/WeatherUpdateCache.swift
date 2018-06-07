import Foundation

private let TRLatestWeatherUpdateFileName = "TRLatestWeatherUpdateFile"

@objc(TRWeatherUpdateCache) public final class WeatherUpdateCache: NSObject {
    @objc public let cachePath: String

    @objc public init(fileName: String, inDirectory directory: URL) {
        cachePath = directory.appendingPathComponent(fileName).path
    }

    @objc public convenience init(fileName: String) {
        let fileManager = FileManager.default
        guard let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Unable to locate user caches directory")
        }
        self.init(fileName: fileName, inDirectory: cachesURL)
    }

    public convenience override init() {
        self.init(fileName: TRLatestWeatherUpdateFileName)
    }

    @objc public var latestWeatherUpdate: WeatherUpdate? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: cachePath) as? WeatherUpdate
    }

    @objc @discardableResult
    public func archiveWeatherUpdate(_ weatherUpdate: WeatherUpdate) -> Bool {
        return NSKeyedArchiver.archiveRootObject(weatherUpdate, toFile: cachePath)
    }
}
