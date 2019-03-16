import Foundation
import os.log

private let cacheQueue: OperationQueue = {
    let queue = OperationQueue()
    queue.maxConcurrentOperationCount = 1
    queue.name = "com.thoughtbot.carlweathers.CacheQueue"
    return queue
}()

@objc(TRWeatherUpdateCache) public final class WeatherUpdateCache: NSObject {
    @objc public static let latestWeatherUpdateFileName = "TRLatestWeatherUpdateFile"

    private let cacheURL: URL

    @objc public init(fileName: String, inDirectory directory: URL) {
        self.cacheURL = directory.appendingPathComponent(fileName)
    }

    @objc public convenience init?(fileName: String) {
        guard let cachesURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.thoughtbot.carlweathers")
        else { return nil }
        self.init(fileName: fileName, inDirectory: cachesURL)
    }

    @objc public var latestWeatherUpdate: WeatherUpdate? {
        do {
            return try NSFileCoordinator(filePresenter: self).coordinateReadingItem(at: cacheURL) { cacheURL in
                NSKeyedUnarchiver.unarchiveObject(withFile: cacheURL.path) as? WeatherUpdate
            }
        } catch {
            if #available(iOS 10.0, iOSApplicationExtension 10.0, *) {
                os_log("Failed to read cached weather update: %{public}@", type: .error, error.localizedDescription)
            } else {
                NSLog("Failed to read cached weather update: %@", error.localizedDescription)
            }
            return nil
        }
    }

    @objc public func archiveWeatherUpdate(
        _ weatherUpdate: WeatherUpdate,
        completionHandler: @escaping (Bool, Error?) -> Void
    ) {
        let writingIntent = NSFileAccessIntent.writingIntent(with: cacheURL)
        NSFileCoordinator(filePresenter: self).coordinate(with: [writingIntent], queue: cacheQueue) { error in
            if let error = error {
                completionHandler(false, error)
            } else {
                let success = NSKeyedArchiver.archiveRootObject(weatherUpdate, toFile: writingIntent.url.path)
                completionHandler(success, nil)
            }
        }
    }
}

extension WeatherUpdateCache: NSFilePresenter {
    public var presentedItemURL: URL? {
        return cacheURL
    }

    public var presentedItemOperationQueue: OperationQueue {
        return cacheQueue
    }
}
