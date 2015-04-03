@import CoreLocation;
#import "TRWeatherUpdate.h"
#import "TRTemperature.h"
#import <OCMock/OCMock.h>

SpecBegin(TRWeatherUpdate)

CLPlacemark* (^stubbedPlacemark) () = ^CLPlacemark* {
    id placemark = OCMClassMock([CLPlacemark class]);
    OCMStub([placemark locality]).andReturn(@"");
    OCMStub([placemark administrativeArea]).andReturn(@"");
    return placemark;
};

NSDictionary* (^weatherConditionsWithTemperature) (NSNumber*) = ^NSDictionary* (NSNumber *temp) {
    NSDictionary *dailyValue = @{@"temperatureMin": @50, @"temperatureMax": @60};
    NSArray *dailyData = @[dailyValue, dailyValue, dailyValue, dailyValue, dailyValue];
    NSDictionary *conditions = (@{ @"currently": @{ @"temperature": temp },
                                   @"daily": @{ @"data": dailyData } });
    return conditions;
};

describe(@"TRWeatherUpdate", ^{
    context(@"currentTemp is higher than currentHigh", ^{
        it(@"updates currentHigh to match", ^{
            NSNumber *currentTemp = @70;
            NSDictionary *conditions = weatherConditionsWithTemperature(currentTemp);
            
            TRWeatherUpdate *update = [[TRWeatherUpdate alloc] initWithPlacemark:stubbedPlacemark()
                                                           currentConditionsJSON:conditions
                                                        yesterdaysConditionsJSON:@{}];
            
            expect(update.currentHigh.fahrenheitValue).to.equal(currentTemp);
        });
        
        it(@"updates currentLow to match", ^{
            NSNumber *currentTemp = @40;
            NSDictionary *conditions = weatherConditionsWithTemperature(currentTemp);
            
            TRWeatherUpdate *update = [[TRWeatherUpdate alloc] initWithPlacemark:stubbedPlacemark()
                                                           currentConditionsJSON:conditions
                                                        yesterdaysConditionsJSON:@{}];
            
            expect(update.currentLow.fahrenheitValue).to.equal(currentTemp);
        });
    });
});

SpecEnd
