#import "CWCurrentConditions.h"
#import "CWTemperature.h"

@interface CWCurrentConditions ()

@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, readwrite) CWTemperature *temperature;
@property (nonatomic, readwrite) CGFloat lowTemperature;
@property (nonatomic, readwrite) CGFloat highTemperature;
@property (nonatomic, readwrite) CGFloat precipitationProbability;

@end

@implementation CWCurrentConditions

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON
{
    CWCurrentConditions *conditions = [self new];
    conditions.conditionsDescription = JSON[@"icon"];
    conditions.temperature = [CWTemperature temperatureFromNumber:JSON[@"currently"][@"temperature"]];

    NSDictionary *todayForecast = [JSON[@"daily"][@"data"] firstObject];
    conditions.lowTemperature = [todayForecast[@"temperatureMin"] floatValue];
    conditions.highTemperature = [todayForecast[@"temperatureMax"] floatValue];
    conditions.precipitationProbability = [JSON[@"currently"][@"precipitationProbability"] floatValue];

    return conditions;
}

@end
