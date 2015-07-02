import Foundation

@objc class CurrentConditions: NSObject, NSCoding {
    let conditionsDescription: String
    let precipitationProbability: Float
    let precipitationType: String
    let currentTemperature: Temperature
    let currentLowTemp: Temperature
    let currentHighTemp: Temperature
    let windBearing: Float
    let windSpeed: Float
    let dailyForecasts: Array<DailyForecast>
    
    init(json: Dictionary<String, AnyObject>) {
        let currentlyJSON = json["currently"] as! Dictionary<String, AnyObject>
        let todaysForecastJSON = (json["daily"]!["data"] as! NSArray).firstObject as! Dictionary<String, AnyObject>
        
        self.conditionsDescription = currentlyJSON["icon"] as! String
        self.windBearing = currentlyJSON["windBearing"] as! Float
        self.windSpeed = currentlyJSON["windSpeed"] as! Float
        self.precipitationProbability = currentlyJSON["precipProbability"] as! Float
        
        // precipitation type
        if let precipType = currentlyJSON["precipType"] as? String {
            self.precipitationType = precipType
        } else {
            self.precipitationType = "rain"
        }
        
        // temperature
        let currentTemp = currentlyJSON["temperature"] as! Int
        var lowTemp = todaysForecastJSON["temperatureMin"] as! Int
        var highTemp = todaysForecastJSON["temperatureMax"] as! Int
        
        if currentTemp < lowTemp {
            lowTemp = currentTemp
        } else if currentTemp > highTemp {
            highTemp = currentTemp
        }
        
        self.currentTemperature = Temperature(fahrenheitValue: currentTemp)
        self.currentLowTemp = Temperature(fahrenheitValue: lowTemp)
        self.currentHighTemp = Temperature(fahrenheitValue: highTemp)
        
        
        // daily forecast
        var forecasts = Array<DailyForecast>()
        let dailyDataArray = json["daily"]!["data"] as! Array<Dictionary<String, AnyObject>>
        for index in 1..<4 {
            let forecast = DailyForecast(json: dailyDataArray[index])
            forecasts.append(forecast)
        }
        self.dailyForecasts = forecasts
    }
    
    init(conditionsDescription: String, precipitationProbability: Float, precipitationType: String, currentTemperature: Temperature, currentLowTemp: Temperature, currentHighTemp: Temperature, windBearing: Float, windSpeed: Float, dailyForecasts: Array<DailyForecast>) {
        self.conditionsDescription = conditionsDescription
        self.precipitationProbability = precipitationProbability
        self.precipitationType = precipitationType
        self.currentTemperature = currentTemperature
        self.currentLowTemp = currentLowTemp
        self.currentHighTemp = currentHighTemp
        self.windBearing = windBearing
        self.windSpeed = windSpeed
        self.dailyForecasts = dailyForecasts
    }
    
    
    // MARK: NSCoding
    enum NSCodingKey: String {
        case ConditionsDescription = "ConditionsDescription"
        case PrecipitationProbability = "PrecipitationProbability"
        case PrecipitationType = "PreciptationType"
        case CurrentTemperature = "CurrentTemperature"
        case CurrentLowTemp = "CurrentLowTemp"
        case CurrentHighTemp = "CurrentHighTemp"
        case WindBearing = "WindBearing"
        case WindSpeed = "WindSpeed"
        case DailyForecasts = "DailyForecasts"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(conditionsDescription, forKey: NSCodingKey.ConditionsDescription.rawValue)
        aCoder.encodeObject(precipitationProbability, forKey: NSCodingKey.PrecipitationProbability.rawValue)
        aCoder.encodeObject(precipitationType, forKey: NSCodingKey.PrecipitationType.rawValue)
        aCoder.encodeObject(currentTemperature, forKey: NSCodingKey.CurrentTemperature.rawValue)
        aCoder.encodeObject(currentLowTemp, forKey: NSCodingKey.CurrentLowTemp.rawValue)
        aCoder.encodeObject(currentHighTemp, forKey: NSCodingKey.CurrentHighTemp.rawValue)
        aCoder.encodeObject(windBearing, forKey: NSCodingKey.WindBearing.rawValue)
        aCoder.encodeObject(windSpeed, forKey: NSCodingKey.WindSpeed.rawValue)
        aCoder.encodeObject(dailyForecasts, forKey: NSCodingKey.DailyForecasts.rawValue)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let conditionsDescription = aDecoder.decodeObjectForKey(NSCodingKey.ConditionsDescription.rawValue) as! String
        let precipitationProbability = aDecoder.decodeObjectForKey(NSCodingKey.PrecipitationProbability.rawValue) as! Float
        let precipitationType = aDecoder.decodeObjectForKey(NSCodingKey.PrecipitationType.rawValue) as! String
        let currentTemperature = aDecoder.decodeObjectForKey(NSCodingKey.CurrentTemperature.rawValue) as! Temperature
        let currentLowTemp = aDecoder.decodeObjectForKey(NSCodingKey.CurrentLowTemp.rawValue) as! Temperature
        let currentHighTemp = aDecoder.decodeObjectForKey(NSCodingKey.CurrentHighTemp.rawValue) as! Temperature
        let windBearing = aDecoder.decodeObjectForKey(NSCodingKey.WindBearing.rawValue) as! Float
        let windSpeed = aDecoder.decodeObjectForKey(NSCodingKey.WindSpeed.rawValue) as! Float
        let forecast = aDecoder.decodeObjectForKey(NSCodingKey.DailyForecasts.rawValue) as! Array<DailyForecast>
        
        self.init(conditionsDescription: conditionsDescription, precipitationProbability: precipitationProbability, precipitationType: precipitationType, currentTemperature: currentTemperature, currentLowTemp: currentLowTemp, currentHighTemp: currentHighTemp, windBearing: windBearing, windSpeed: windSpeed, dailyForecasts: forecast)
    }
}