import Foundation

@objc class WeatherUpdateCache: NSObject {
    static let LatestWeatherUpdateFileName = "LatestWeatherUpdateFile"
    
    class func archive(weatherUpdate: WeatherUpdate) -> Bool {
        if let path = latestWeatherUpdateFilePath() {
            return NSKeyedArchiver.archiveRootObject(weatherUpdate, toFile: path)
        }
        return false
    }
    
    class func latestWeatherUpdate() -> WeatherUpdate? {
        if let path = latestWeatherUpdateFilePath(), let weatherUpdate = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? WeatherUpdate {
            return weatherUpdate
        }
        return nil
    }
    
    class func latestWeatherUpdateFilePath() -> String? {
        let documentPaths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as? NSURL
        return documentPaths?.URLByAppendingPathComponent(LatestWeatherUpdateFileName).path
    }
}