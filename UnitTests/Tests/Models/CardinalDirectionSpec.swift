@testable import Tropos
import Quick
import Nimble

final class CardinalDirectionSpec: QuickSpec {
    override func spec() {
        it("abbreviates each cardinal direction correctly") {
            expect(CardinalDirection.North.abbreviation) == "N"
            expect(CardinalDirection.South.abbreviation) == "S"
            expect(CardinalDirection.East.abbreviation) == "E"
            expect(CardinalDirection.West.abbreviation) == "W"
            expect(CardinalDirection.NorthEast.abbreviation) == "NE"
            expect(CardinalDirection.SouthEast.abbreviation) == "SE"
            expect(CardinalDirection.NorthWest.abbreviation) == "NW"
            expect(CardinalDirection.SouthWest.abbreviation) == "SW"
        }
    }
}
