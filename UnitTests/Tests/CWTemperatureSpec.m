#import "CWTemperature.h"

SpecBegin(CWTemperature)

describe(@"CWTemperature", ^{
    describe(@"compare:", ^{
        context(@"temperature is 10 less than the receiver", ^{
            it(@"returns hotter", ^{
                CWTemperature *first = [CWTemperature temperatureFromNumber:@(10)];
                CWTemperature *second = [CWTemperature temperatureFromNumber:@(0)];
                
                expect([first compare:second]).to.equal(CWTemperatureComparisonHotter);
            });
        });

        context(@"temperature is within 10 less of the receiver", ^{
            it(@"returns warmer", ^{
                CWTemperature *first = [CWTemperature temperatureFromNumber:@(9)];
                CWTemperature *second = [CWTemperature temperatureFromNumber:@(0)];
                
                expect([first compare:second]).to.equal(CWTemperatureComparisonWarmer);
            });
        });

        context(@"temperature is within 10 greater of the receiver", ^{
            it(@"returns cooler", ^{
                CWTemperature *first = [CWTemperature temperatureFromNumber:@(0)];
                CWTemperature *second = [CWTemperature temperatureFromNumber:@(9)];
                
                expect([first compare:second]).to.equal(CWTemperatureComparisonCooler);
            });
        });

        context(@"temperature is 10 greater than the receiver", ^{
            it(@"returns colder", ^{
                CWTemperature *first = [CWTemperature temperatureFromNumber:@(0)];
                CWTemperature *second = [CWTemperature temperatureFromNumber:@(10)];
                
                expect([first compare:second]).to.equal(CWTemperatureComparisonColder);
            });
        });

        context(@"temperatures are the same", ^{
            it(@"returns same", ^{
                CWTemperature *first = [CWTemperature temperatureFromNumber:@(0)];
                CWTemperature *second = [CWTemperature temperatureFromNumber:@(0)];
                
                expect([first compare:second]).to.equal(CWTemperatureComparisonSame);
            });
        });
    });
});

SpecEnd
