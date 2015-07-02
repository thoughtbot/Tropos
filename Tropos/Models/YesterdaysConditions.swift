import Foundation

@objc class YesterdaysConditions: NSObject, NSCoding {
    let temperature: Temperature
    
    init(temperature: Int) {
        self.temperature = Temperature(fahrenheitValue: temperature)
    }
    
    // NSCoding
    enum NSCodingKey: String {
        case Temperature = "Temperature"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(temperature.fahrenheitValue, forKey: NSCodingKey.Temperature.rawValue)
    }
    
    convenience required init(coder aDecoder: NSCoder) {
        let temperatureValue = aDecoder.decodeIntegerForKey(NSCodingKey.Temperature.rawValue)
        self.init(temperature: temperatureValue)
    }
}