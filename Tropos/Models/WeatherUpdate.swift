import Foundation
import CoreLocation

@objc class WeatherUpdate: NSObject, NSCoding {
    let city: String
    let state: String
    let conditionsDescription: String
    let precipitationType: String
    
    let currentTemperature: Temperature
    let currentLow: Temperature
    let currentHigh: Temperature
    let yesterdaysTemperature: Temperature
    
    let precipitationPercentage: Float
    let windSpeed: Float
    let windBearing: Float
    
    let date: NSDate
    
    let dailyForecasts: Array<DailyForecast>
    
    let placemark: CLPlacemark
    let currentConditions: NSDictionary
    let yesterdaysConditions: NSDictionary
    
    init(placemark: CLPlacemark, currentConditions: Dictionary<String, AnyObject>, yesterdaysConditions: Dictionary<String, AnyObject>, date: NSDate? = nil) {
        self.city = placemark.locality ?? ""
        self.state = placemark.administrativeArea ?? ""
        self.placemark = placemark
        
        self.currentConditions = currentConditions
        self.yesterdaysConditions = yesterdaysConditions

        let todaysConditions = currentConditions["currently"] as! Dictionary<String, AnyObject>
        let yesterdaysConditions = yesterdaysConditions["currently"] as! Dictionary<String, AnyObject>
        let todaysForecast = (currentConditions["daily"]!["data"] as! NSArray).firstObject as! NSDictionary
        
        // set precipitation percentage
        self.precipitationPercentage = todaysForecast["precipProbability"] as! Float
        if let precipType = todaysForecast["precipType"] as? String {
            self.precipitationType = precipType
        } else {
            self.precipitationType = "rain"
        }
        
        self.conditionsDescription = todaysConditions["icon"] as! String
        
        // temperature
        self.currentTemperature = Temperature(fahrenheitValue: todaysConditions["temperature"] as! Int)
        var currentLow = Temperature(fahrenheitValue: todaysForecast["temperatureMin"] as! Int)
        var currentHigh = Temperature(fahrenheitValue: todaysForecast["temperatureMax"] as! Int)
        
        if self.currentTemperature.fahrenheitValue < currentLow.fahrenheitValue {
            currentLow = self.currentTemperature
        } else if self.currentTemperature.fahrenheitValue > currentHigh.fahrenheitValue {
            currentHigh = self.currentTemperature
        }
        
        self.currentLow = currentLow
        self.currentHigh = currentHigh
        
        self.yesterdaysTemperature = Temperature(fahrenheitValue: yesterdaysConditions["temperature"] as! Int)
        self.windBearing = todaysConditions["windBearing"] as! Float
        self.windSpeed = todaysConditions["windSpeed"] as! Float
        
        if let date = date {
            self.date = date
        } else {
            self.date = NSDate()
        }
        
        // daily forecasts
        var dailyForecasts = Array<DailyForecast>()
        for index in 1...4 {
            let forecast = DailyForecast(json: (currentConditions["daily"]!["data"] as! NSArray)[index] as! Dictionary<String, AnyObject>)
            dailyForecasts.append(forecast)
        }
        
        self.dailyForecasts = dailyForecasts
    }
    
    // MARK: NSCoding
    enum NSCodingKey: String {
        case CurrentConditions = "TRCurrentConditions"
        case YesterdaysConditions = "TRYesterdaysConditionsConditions"
        case Placemark = "TRPlacemark"
        case Date = "TRDateAt"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(currentConditions, forKey: NSCodingKey.CurrentConditions.rawValue)
        aCoder.encodeObject(yesterdaysConditions, forKey: NSCodingKey.YesterdaysConditions.rawValue)
        aCoder.encodeObject(placemark, forKey: NSCodingKey.Placemark.rawValue)
        aCoder.encodeObject(date, forKey: NSCodingKey.Date.rawValue)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let placemark = aDecoder.decodeObjectForKey(NSCodingKey.Placemark.rawValue) as! CLPlacemark
        let currentConditions = aDecoder.decodeObjectForKey(NSCodingKey.CurrentConditions.rawValue) as! Dictionary<String, AnyObject>
        let yesterdaysConditions = aDecoder.decodeObjectForKey(NSCodingKey.YesterdaysConditions.rawValue) as! Dictionary<String, AnyObject>
        let date = aDecoder.decodeObjectForKey(NSCodingKey.Date.rawValue) as! NSDate
        
        self.init(placemark: placemark, currentConditions: currentConditions, yesterdaysConditions: yesterdaysConditions, date: date)
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
        "Temperature": self.currentTemperature.fahrenheitValue,
        "Low Temperature": self.currentLow.fahrenheitValue,
        "High Temperature": self.currentHigh.fahrenheitValue,
        "Wind Speed": self.windSpeed,
        "Wind Bearing": self.windBearing,
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