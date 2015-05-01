#import "TRPrecipitation.h"

SpecBegin(TRPrecipitation)

describe(@"TRPrecipitation", ^{
    describe(@"precipitationDescription", ^{
        context(@"0% chance of precipitation", ^{
            it(@"returns none", ^{
                TRPrecipitation *precipitation = [TRPrecipitation precipitationFromProbability:(CGFloat)0 precipitationType:@""];

                expect([precipitation chance]).to.equal(TRPrecipitationChanceNone);
            });
        });

        context(@"between 1% and 30% chance of precipitation", ^{
            it(@"returns slight", ^{
                TRPrecipitation *precipitation = [TRPrecipitation precipitationFromProbability:(CGFloat)20 precipitationType:@""];

                expect([precipitation chance]).to.equal(TRPrecipitationChanceSlight);
            });
        });

        context(@"greater than 30% chance of precipitation", ^{
            it(@"returns good", ^{
                TRPrecipitation *precipitation = [TRPrecipitation precipitationFromProbability:(CGFloat)100 precipitationType:@""];

                expect([precipitation chance]).to.equal(TRPrecipitationChanceGood);
            });
        });
    });
});

SpecEnd
