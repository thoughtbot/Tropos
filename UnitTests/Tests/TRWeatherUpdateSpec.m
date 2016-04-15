@import CoreLocation;
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "TRWeatherUpdate.h"
#import "UnitTests-Swift.h"

QuickSpecBegin(TRWeatherUpdateSpec)

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

NSDictionary* (^weatherConditionsWithPrecipitation) (NSString*) = ^NSDictionary* (NSString *precipitation) {
    NSDictionary *dailyValue = @{@"temperatureMin": @50, @"temperatureMax": @60, @"precipProbability": precipitation, @"precipType": @"rain" };
    NSArray *dailyData = @[dailyValue, dailyValue, dailyValue, dailyValue, dailyValue];
    NSDictionary *conditions = (@{ @"currently": @{ @"temperature": @90 },
                                   @"daily": @{ @"data": dailyData } });
    return conditions;
};

NSDictionary* (^weatherConditionsWithoutPrecipitationType) (NSString*) = ^NSDictionary* (NSString *precipitation) {
    NSDictionary *dailyValue = @{@"temperatureMin": @50, @"temperatureMax": @60, @"precipProbability": precipitation};
    NSArray *dailyData = @[dailyValue, dailyValue, dailyValue, dailyValue, dailyValue];
    NSDictionary *conditions = (@{ @"currently": @{ @"temperature": @90 },
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

    context(@"with a chance of precipitation", ^{
        it(@"stores the precipitation probability and type", ^{
            NSString *probability = @"0.43";
            NSDictionary *conditions = weatherConditionsWithPrecipitation(probability);

            TRWeatherUpdate *update = [[TRWeatherUpdate alloc] initWithPlacemark:stubbedPlacemark()
                                                           currentConditionsJSON:conditions
                                                        yesterdaysConditionsJSON:@{}];

            expect(round(update.precipitationPercentage * 100)).to.equal(43.0f);
            expect(update.precipitationType).to.equal(@"rain");
        });
    });

    context(@"with a no chance of precipitation", ^{
        it(@"stores the precipitation probability and defaults the type", ^{
            NSString *probability = @"0";
            NSDictionary *conditions = weatherConditionsWithoutPrecipitationType(probability);

            TRWeatherUpdate *update = [[TRWeatherUpdate alloc] initWithPlacemark:stubbedPlacemark()
                                                           currentConditionsJSON:conditions
                                                        yesterdaysConditionsJSON:@{}];

            expect(update.precipitationPercentage).to.equal(0.0f);
            expect(update.precipitationType).to.equal(@"rain");
        });
    });
});

SpecEnd
