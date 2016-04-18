#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import "TRBearingFormatter.h"

SpecBegin(TRBearingFormatter)

describe(@"TRBearingFormatter", ^{
    describe(@"cardinalDirectionStringFromBearing:", ^{
        it(@"returns the correct cardinal direction", ^{
            expect([TRBearingFormatter cardinalDirectionStringFromBearing:0]).to.equal(@"North");
            expect([TRBearingFormatter cardinalDirectionStringFromBearing:90]).to.equal(@"East");
            expect([TRBearingFormatter cardinalDirectionStringFromBearing:180]).to.equal(@"South");
            expect([TRBearingFormatter cardinalDirectionStringFromBearing:270]).to.equal(@"West");
        });
    });

    describe(@"abbreviatedCardinalDirectionStringFromBearing:", ^{
        it(@"returns the correct cardinal direction", ^{
            expect([TRBearingFormatter abbreviatedCardinalDirectionStringFromBearing:45]).to.equal(@"NE");
            expect([TRBearingFormatter abbreviatedCardinalDirectionStringFromBearing:135]).to.equal(@"SE");
            expect([TRBearingFormatter abbreviatedCardinalDirectionStringFromBearing:225]).to.equal(@"SW");
            expect([TRBearingFormatter abbreviatedCardinalDirectionStringFromBearing:315]).to.equal(@"NW");
        });
    });
});

SpecEnd
