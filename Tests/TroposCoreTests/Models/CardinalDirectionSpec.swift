import TroposCore
import Quick
import Nimble

final class CardinalDirectionSpec: QuickSpec {
    override func spec() {
        it("abbreviates each cardinal direction correctly") {
            expect(CardinalDirection.north.abbreviation) == "N"
            expect(CardinalDirection.south.abbreviation) == "S"
            expect(CardinalDirection.east.abbreviation) == "E"
            expect(CardinalDirection.west.abbreviation) == "W"
            expect(CardinalDirection.northEast.abbreviation) == "NE"
            expect(CardinalDirection.southEast.abbreviation) == "SE"
            expect(CardinalDirection.northWest.abbreviation) == "NW"
            expect(CardinalDirection.southWest.abbreviation) == "SW"
        }
    }
}
