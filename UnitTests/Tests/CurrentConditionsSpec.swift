import Foundation
import Quick
import Nimble

class CurrentConditionsSpec: QuickSpec {
    
    class func currentConditionsJSON(currentTemp: Int = 30, temperatureMax: Int = 50, temperatureMin: Int = 10, precipitationProbability: Float = 0.7) -> Dictionary<String, AnyObject> {
        let currently = [
            "icon": "some description",
            "windBearing": 3.0,
            "windSpeed": 1.5,
            "precipProbability": precipitationProbability,
//            "precipType" = "rain"
            "temperature": currentTemp
        ]
        
        let dailyData = [
            "temperatureMin": temperatureMin,
            "temperatureMax": temperatureMax,
            "time": 30,
            "icon": "some description"
        ]
        
        return [
            "currently": currently,
            "daily": [
                "data": [dailyData, dailyData, dailyData, dailyData]
            ]
        ]
    }
    
    override func spec() {
        describe("CurrentConditions") {
            it("Should correctly fill newly created object") {
                let conditions = CurrentConditions(json: CurrentConditionsSpec.currentConditionsJSON())
                expect(conditions.conditionsDescription).to(equal("some description"))
                expect(conditions.precipitationProbability).to(equal(0.7))
                expect(conditions.precipitationType).to(equal("rain"))
                expect(conditions.currentTemperature.fahrenheitValue).to(equal(30))
                expect(conditions.currentLowTemp.fahrenheitValue).to(equal(10))
                expect(conditions.currentHighTemp.fahrenheitValue).to(equal(50))
                expect(conditions.windBearing).to(equal(3.0))
                expect(conditions.windSpeed).to(equal(1.5))
                expect(conditions.dailyForecasts.count).to(equal(3))
            }
            
            context("temperature update") {
                it("Should override max temperature") {
                    let conditions = CurrentConditions(json: CurrentConditionsSpec.currentConditionsJSON(temperatureMax: 20))
                    expect(conditions.currentHighTemp.fahrenheitValue).to(equal(30))
                }
                
                it("Should override min temperature") {
                    let conditions = CurrentConditions(json: CurrentConditionsSpec.currentConditionsJSON(currentTemp: 3))
                    expect(conditions.currentLowTemp.fahrenheitValue).to(equal(3))
                }
            }
            
            context("Archiving and unarchiving") {
                it("should be able to be archived") {
                    let conditions = CurrentConditions(json: CurrentConditionsSpec.currentConditionsJSON())
                    expect(NSKeyedArchiver.archivedDataWithRootObject(conditions)).toNot(raiseException())
                }
                
                it("should be able to be unarchived") {
                    let conditions = CurrentConditions(json: CurrentConditionsSpec.currentConditionsJSON())
                    let data = NSKeyedArchiver.archivedDataWithRootObject(conditions)
                    expect(NSKeyedUnarchiver.unarchiveObjectWithData(data)).toNot(raiseException())
                }
            }
            
            context("Precipitation probability") {
                it("stores the precipittion probability and type") {
                    let conditions = CurrentConditions(json: CurrentConditionsSpec.currentConditionsJSON(precipitationProbability: 0.43))
                    expect(round(conditions.precipitationProbability * 100.0)).to(equal(43.0))
                    expect(conditions.precipitationType).to(equal("rain"))
                }
                
                it("have no changes of precipitation and stores probability and type") {
                    let conditions = CurrentConditions(json: CurrentConditionsSpec.currentConditionsJSON(precipitationProbability: 0))
                    expect(round(conditions.precipitationProbability * 100.0)).to(equal(0))
                    expect(conditions.precipitationType).to(equal("rain"))
                }
            }
        }
    }
}
