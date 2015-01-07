#import "CWTemperature.h"

SpecBegin(CWTemperature)

describe(@"CWTemperature", ^{
    describe(@"compare:", ^{
        context(@"temperature is 10 less than the receiver", ^{
            it(@"returns hotter", ^{
                CWTemperature *first = [CWTemperature temperatureFromFahrenheit:@(10)];
                CWTemperature *second = [CWTemperature temperatureFromFahrenheit:@(0)];
                
                expect([first comparedTo:second]).to.equal(CWTemperatureComparisonHotter);
            });
        });

        context(@"temperature is within 10 less of the receiver", ^{
            it(@"returns warmer", ^{
                CWTemperature *first = [CWTemperature temperatureFromFahrenheit:@(9)];
                CWTemperature *second = [CWTemperature temperatureFromFahrenheit:@(0)];
                
                expect([first comparedTo:second]).to.equal(CWTemperatureComparisonWarmer);
            });
        });

        context(@"temperature is within 10 greater of the receiver", ^{
            it(@"returns cooler", ^{
                CWTemperature *first = [CWTemperature temperatureFromFahrenheit:@(0)];
                CWTemperature *second = [CWTemperature temperatureFromFahrenheit:@(9)];
                
                expect([first comparedTo:second]).to.equal(CWTemperatureComparisonCooler);
            });
        });

        context(@"temperature is 10 greater than the receiver", ^{
            it(@"returns colder", ^{
                CWTemperature *first = [CWTemperature temperatureFromFahrenheit:@(0)];
                CWTemperature *second = [CWTemperature temperatureFromFahrenheit:@(10)];
                
                expect([first comparedTo:second]).to.equal(CWTemperatureComparisonColder);
            });
        });

        context(@"temperatures are the same", ^{
            it(@"returns same", ^{
                CWTemperature *first = [CWTemperature temperatureFromFahrenheit:@(0)];
                CWTemperature *second = [CWTemperature temperatureFromFahrenheit:@(0)];
                
                expect([first comparedTo:second]).to.equal(CWTemperatureComparisonSame);
            });
        });
    });
});

SpecEnd
