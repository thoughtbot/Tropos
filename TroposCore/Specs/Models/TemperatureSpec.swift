import TroposCore
import Quick
import Nimble

class TemperatureSpec: QuickSpec {
    override func spec() {
        describe("Temperature") {
            func compare(temp1: Int, _ temp2: Int) -> TemperatureComparison {
                let t1 = Temperature(fahrenheitValue: temp1)
                let t2 = Temperature(fahrenheitValue: temp2)
                return t1.comparedTo(t2)
            }
            
            context("temperature is 10 less than the receiver") {
                it("is above freezing and returns hotter") {
                    expect(compare(80, 70)).to(equal(TemperatureComparison.Hotter))
                }
                
                it("is below freezing and returns warmer") {
                    expect(compare(21, 10)).to(equal(TemperatureComparison.Warmer))
                }
            }
            
            context("temperature is withing 10 less of the receiver") {
                it("returns warmer") {
                    expect(compare(9, 0)).to(equal(TemperatureComparison.Warmer))
                }
            }
            
            context("temperature is within 10 greater of the receiver") {
                it("returns cooler") {
                    expect(compare(0, 9)).to(equal(TemperatureComparison.Cooler))
                }
            }
            
            context("temperature is 10 greater than the receiver") {
                it("temperature is above 75 and returns cooler") {
                    expect(compare(85, 95)).to(equal(TemperatureComparison.Cooler))
                }
                
                it("temperature is below 75 and returns colder") {
                    expect(compare(0, 10)).to(equal(TemperatureComparison.Colder))
                }
            }
            
            context("temperatures are the same") {
                it("returns same") {
                    expect(compare(0, 0)).to(equal(TemperatureComparison.Same))
                }
            }
            
            context("Conversion to celsius should return correct values") {
                it("should convert 75 to 24") {
                    expect(Temperature(fahrenheitValue: 75).celsiusValue).to(equal(24))
                }
                
                it("should convert 50 to 10") {
                    expect(Temperature(fahrenheitValue: 50).celsiusValue).to(equal(10))
                }
            }
        }
    }
}
