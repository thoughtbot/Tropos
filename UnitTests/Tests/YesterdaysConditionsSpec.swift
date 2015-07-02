import Foundation
import Quick
import Nimble

class YesterdaysConditionsSpec: QuickSpec {
    override func spec() {
        describe("YesterdaysConditions") {
            it("Should return correct temperature after initialization") {
                expect(YesterdaysConditions(temperature: 10).temperature.fahrenheitValue).to(equal(10))
            }
            
            it("Should be able to be archived") {
                let conditions = YesterdaysConditions(temperature: 10)
                expect(NSKeyedArchiver.archivedDataWithRootObject(conditions)).toNot(raiseException())
            }
            
            it("Should be able to be unarchived") {
                let conditions = YesterdaysConditions(temperature: 10)
                let archived = NSKeyedArchiver.archivedDataWithRootObject(conditions)
                expect(NSKeyedUnarchiver.unarchiveObjectWithData(archived)).toNot(raiseException())
            }
        }
    }
}