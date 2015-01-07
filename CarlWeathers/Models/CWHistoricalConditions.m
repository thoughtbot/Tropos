#import "CWHistoricalConditions.h"
#import "CWTemperature.h"

@interface CWHistoricalConditions ()

@property (nonatomic, readwrite) CWTemperature *temperature;

@end

@implementation CWHistoricalConditions

+ (instancetype)historicalConditionsFromJSON:(NSDictionary *)JSON
{
    CWHistoricalConditions *conditions = [self new];
    conditions.temperature = [CWTemperature temperatureFromFahrenheit:JSON[@"currently"][@"temperature"]];
    return conditions;
}

@end
