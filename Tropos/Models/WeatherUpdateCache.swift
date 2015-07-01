import Foundation

@objc class WeatherUpdateCache: NSObject {
    static let TRLatestWeatherUpdateFileName = "TRLatestWeatherUpdateFile"
    
    class func archive(weatherUpdate: TRWeatherUpdate) -> Bool {
        if let path = latestWeatherUpdateFilePath() {
            return NSKeyedArchiver.archiveRootObject(weatherUpdate, toFile: path)
        }
        return false
    }
    
    class func latestWeatherUpdate() -> TRWeatherUpdate? {
        if let path = latestWeatherUpdateFilePath(), let weatherUpdate = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? TRWeatherUpdate {
            return weatherUpdate
        }
        return nil
    }
    
    class func latestWeatherUpdateFilePath() -> String? {
        let documentPaths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as? NSURL
        return documentPaths?.URLByAppendingPathComponent(TRLatestWeatherUpdateFileName).path
    }
}