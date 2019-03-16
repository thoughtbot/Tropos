import Foundation
import Nimble
import Quick
import TroposCore

class PrecipitationSpec: QuickSpec {
    override func spec() {
        describe("Precipitation") {
            context("precipitation chance") {
                it("returns none for 0% chance of precipitation") {
                    let precipitation = Precipitation(probability: 0.0, type: "")
                    expect(precipitation.chance).to(equal(PrecipitationChance.none))
                }

                it("returns slight for 1 - 30% chance of precipitation") {
                    let precipitation = Precipitation(probability: 0.2, type: "")
                    expect(precipitation.chance).to(equal(PrecipitationChance.slight))
                }

                it("returns good for chance greater than 30% of precipitation") {
                    let precipitation = Precipitation(probability: 0.7, type: "")
                    expect(precipitation.chance).to(equal(PrecipitationChance.good))
                }
            }
        }
    }
}
