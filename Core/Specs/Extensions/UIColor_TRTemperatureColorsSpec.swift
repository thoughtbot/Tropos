@testable import TroposCore
import Quick
import Nimble

final class UIColor_TRTemperatureColorsSpec: QuickSpec {
    override func spec() {
        describe("UIColor+TRTemperatureColors") {
            describe("lighterColorByAmount") {
                it("blends with white") {
                    let warmer = UIColor.warmerColor

                    let blendedColor = warmer.lighten(by: 0.5)

                    var hue: CGFloat = 0
                    var saturation: CGFloat = 0
                    var brightness: CGFloat = 0
                    var alpha: CGFloat = 0
                    blendedColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

                    expect(saturation).to(equal(0.5))
                    expect(brightness).to(beCloseTo(0.985, within: 0.001))
                }
            }
        }
    }
}
