import Foundation

let recentLocationMaximumElapsedTimeInterval: TimeInterval = 5

@objc extension CLLocation {
    var isStale: Bool {
        let now = NSDate()
        let recentLocationElapsedTime = now.timeIntervalSince(self.timestamp)
        return recentLocationElapsedTime > recentLocationMaximumElapsedTimeInterval
    }
}
