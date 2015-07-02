import Foundation
import CoreLocation

@objc class WeatherUpdate: NSObject, NSCoding, AnalyticsEvent {
    let placemark: CLPlacemark
    let weatherConditions: WeatherConditions
    let date: NSDate
    
    var city: String { return self.placemark.locality ?? "" }
    var state: String { return self.placemark.administrativeArea ?? "" }
    
    init(placemark: CLPlacemark, weatherConditions: WeatherConditions, date: NSDate? = nil) {
        self.placemark = placemark
        self.weatherConditions = weatherConditions
        self.date = date ?? NSDate()
    }
    
    // MARK: NSCoding
    enum NSCodingKey: String {
        case Placemark = "Placemark"
        case WeatherConditions = "WeatherConditions"
        case Date = "Date"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(weatherConditions, forKey: NSCodingKey.WeatherConditions.rawValue)
        aCoder.encodeObject(placemark, forKey: NSCodingKey.Placemark.rawValue)
        aCoder.encodeObject(date, forKey: NSCodingKey.Date.rawValue)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let placemark = aDecoder.decodeObjectForKey(NSCodingKey.Placemark.rawValue) as! CLPlacemark
        let weatherConditions = aDecoder.decodeObjectForKey(NSCodingKey.WeatherConditions.rawValue) as! WeatherConditions
        let date = aDecoder.decodeObjectForKey(NSCodingKey.Date.rawValue) as! NSDate
        
        self.init(placemark: placemark, weatherConditions: weatherConditions, date: date)
    }
    
    // MARK: TRAnalyticsEvent
    var eventName: String {
        return "Weather Update"
    }
    
    var eventProperties: Dictionary<String, AnyObject> {
        return [
        "Latitude": analyticsLatitude(),
        "Longitude": analyticsLongitude(),
        "City": self.city,
        "State": self.state,
        "Temperature": self.weatherConditions.current.currentTemperature.fahrenheitValue,
        "Low Temperature": self.weatherConditions.current.currentLowTemp.fahrenheitValue,
        "High Temperature": self.weatherConditions.current.currentHighTemp.fahrenheitValue,
        "Wind Speed": self.weatherConditions.current.windSpeed,
        "Wind Bearing": self.weatherConditions.current.windBearing,
        "Update Date": self.date
        ]
    }
    
    private func analyticsLatitude() -> CLLocationDegrees {
        return anonymize(self.placemark.location.coordinate.latitude)
    }
    
    private func analyticsLongitude() -> CLLocationDegrees {
        return anonymize(self.placemark.location.coordinate.longitude)
    }
    
    private func anonymize(degrees:CLLocationDegrees) -> CLLocationDegrees {
        return round((degrees * 100) / 100)
    }
}