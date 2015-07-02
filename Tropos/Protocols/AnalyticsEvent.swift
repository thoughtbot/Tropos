import Foundation

@objc protocol AnalyticsEvent: class {
    var eventName: String {get}
    var eventProperties: Dictionary<String, AnyObject> {get}
}
