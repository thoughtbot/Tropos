import Foundation
import Quick
import Nimble

class WeatherConditionsSpec: QuickSpec {
    
    class func yesterdaysConditionsJSON() -> Dictionary<String, AnyObject> {
        return ["currently": ["temperature": 30]]
    }
    
    override func spec() {
        describe("WeatherConditions") {
            it("should be created from JSON") {
                let conditions = WeatherConditions(currentConditionsJSON: CurrentConditionsSpec.currentConditionsJSON(currentTemp: 40), yesterdaysConditionsJSON: WeatherConditionsSpec.yesterdaysConditionsJSON())
                expect(conditions.yesterday.temperature.fahrenheitValue).to(equal(30))
                expect(conditions.current.currentTemperature.fahrenheitValue).to(equal(40))
            }
            
            context("Archiving and unarchiving") {
                it("should be able to be archived") {
                    let conditions = WeatherConditions(currentConditionsJSON: CurrentConditionsSpec.currentConditionsJSON(), yesterdaysConditionsJSON: WeatherConditionsSpec.yesterdaysConditionsJSON())
                    expect(NSKeyedArchiver.archivedDataWithRootObject(conditions)).notTo(raiseException())
                }
                
                it("should be able to be unarchived") {
                    let conditions = WeatherConditions(currentConditionsJSON: CurrentConditionsSpec.currentConditionsJSON(), yesterdaysConditionsJSON: WeatherConditionsSpec.yesterdaysConditionsJSON())
                    let data = NSKeyedArchiver.archivedDataWithRootObject(conditions)
                    expect(NSKeyedUnarchiver.unarchiveObjectWithData(data)).notTo(raiseException())
                }
            }
        }
    }
}