import Foundation

extension NSDate {
    convenience init?(ISO8601String: String) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.dateFromString(ISO8601String) else { return nil }
        let timeInterval = date.timeIntervalSinceDate(NSDate(timeIntervalSince1970: 0))
        self.init(timeIntervalSince1970: timeInterval)
    }
}
