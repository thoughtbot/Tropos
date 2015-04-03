#import "TRTemperature.h"

SpecBegin(TRTemperature)

describe(@"TRTemperature", ^{
    describe(@"compare:", ^{
        context(@"temperature is 10 less than the receiver", ^{
            context(@"temperature is above freezing", ^{
                it(@"returns hotter", ^{
                    TRTemperature *first = [TRTemperature temperatureFromFahrenheit:@(80)];
                    TRTemperature *second = [TRTemperature temperatureFromFahrenheit:@(70)];

                    expect([first comparedTo:second]).to.equal(TRTemperatureComparisonHotter);
                });
            });

            context(@"temperature is below freezing", ^{
                it(@"returns warmer", ^{
                    TRTemperature *first = [TRTemperature temperatureFromFahrenheit:@(21)];
                    TRTemperature *second = [TRTemperature temperatureFromFahrenheit:@(10)];

                    expect([first comparedTo:second]).to.equal(TRTemperatureComparisonWarmer);
                });
            });
        });

        context(@"temperature is within 10 less of the receiver", ^{
            it(@"returns warmer", ^{
                TRTemperature *first = [TRTemperature temperatureFromFahrenheit:@(9)];
                TRTemperature *second = [TRTemperature temperatureFromFahrenheit:@(0)];
                
                expect([first comparedTo:second]).to.equal(TRTemperatureComparisonWarmer);
            });
        });

        context(@"temperature is within 10 greater of the receiver", ^{
            it(@"returns cooler", ^{
                TRTemperature *first = [TRTemperature temperatureFromFahrenheit:@(0)];
                TRTemperature *second = [TRTemperature temperatureFromFahrenheit:@(9)];
                
                expect([first comparedTo:second]).to.equal(TRTemperatureComparisonCooler);
            });
        });

        context(@"temperature is 10 greater than the receiver", ^{
            context(@"temperature is above 75", ^{
                it(@"returns cooler", ^{
                    TRTemperature *first = [TRTemperature temperatureFromFahrenheit:@(85)];
                    TRTemperature *second = [TRTemperature temperatureFromFahrenheit:@(95)];

                    expect([first comparedTo:second]).to.equal(TRTemperatureComparisonCooler);
                });
            });

            context(@"temperature is below 75", ^{
                it(@"returns colder", ^{
                    TRTemperature *first = [TRTemperature temperatureFromFahrenheit:@(0)];
                    TRTemperature *second = [TRTemperature temperatureFromFahrenheit:@(10)];

                    expect([first comparedTo:second]).to.equal(TRTemperatureComparisonColder);
                });
            });
        });

        context(@"temperatures are the same", ^{
            it(@"returns same", ^{
                TRTemperature *first = [TRTemperature temperatureFromFahrenheit:@(0)];
                TRTemperature *second = [TRTemperature temperatureFromFahrenheit:@(0)];
                
                expect([first comparedTo:second]).to.equal(TRTemperatureComparisonSame);
            });
        });
    });
});

SpecEnd
