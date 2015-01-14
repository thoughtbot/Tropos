#import "TRHistoricalConditions.h"
#import "TRTemperature.h"

@interface TRHistoricalConditions ()

@property (nonatomic, readwrite) TRTemperature *temperature;

@end

@implementation TRHistoricalConditions

+ (instancetype)historicalConditionsFromJSON:(NSDictionary *)JSON
{
    TRHistoricalConditions *conditions = [self new];
    conditions.temperature = [TRTemperature temperatureFromFahrenheit:JSON[@"currently"][@"temperature"]];
    return conditions;
}

@end
