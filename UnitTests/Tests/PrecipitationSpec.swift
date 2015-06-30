import Foundation
import Quick
import Nimble

class PrecipitationSpec: QuickSpec {
    override func spec() {
        describe("Precipitation") {
            context("precipitation chance") {
                it("returns none for 0% chance of precipitation") {
                    let precipitation = Precipitation(probability: 0.0, type: "")
                    expect{precipitation.chance}.to(equal(PrecipitationChance.None))
                }
                
                it("returns slight for 1 - 30% chance of precipitation") {
                    let precipitation = Precipitation(probability: 20.0, type: "")
                    expect{precipitation.chance}.to(equal(PrecipitationChance.Slight))
                }
                
                it("returns good for chance greater than 30% of precipitation") {
                    let precipitation = Precipitation(probability: 70.0, type: "")
                    expect{precipitation.chance}.to(equal(PrecipitationChance.Good))
                }
            }
        }
    }
}