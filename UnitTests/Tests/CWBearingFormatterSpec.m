#import "CWBearingFormatter.h"

SpecBegin(CWBearingFormatter)

describe(@"CWBearingFormatter", ^{
    describe(@"cardinalDirectionStringFromBearing:", ^{
        it(@"returns the correct cardinal direction", ^{
            expect([CWBearingFormatter cardinalDirectionStringFromBearing:0]).to.equal(@"North");
            expect([CWBearingFormatter cardinalDirectionStringFromBearing:90]).to.equal(@"East");
            expect([CWBearingFormatter cardinalDirectionStringFromBearing:180]).to.equal(@"South");
            expect([CWBearingFormatter cardinalDirectionStringFromBearing:270]).to.equal(@"West");
        });
    });
    
    describe(@"abbreviatedCardinalDirectionStringFromBearing:", ^{
        it(@"returns the correct cardinal direction", ^{
            expect([CWBearingFormatter abbreviatedCardinalDirectionStringFromBearing:45]).to.equal(@"NE");
            expect([CWBearingFormatter abbreviatedCardinalDirectionStringFromBearing:135]).to.equal(@"SE");
            expect([CWBearingFormatter abbreviatedCardinalDirectionStringFromBearing:225]).to.equal(@"SW");
            expect([CWBearingFormatter abbreviatedCardinalDirectionStringFromBearing:315]).to.equal(@"NW");
        });
    });
});

SpecEnd
