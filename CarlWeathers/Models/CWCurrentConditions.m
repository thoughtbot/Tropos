#import "CWCurrentConditions.h"

@interface CWCurrentConditions ()

@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, readwrite) CGFloat temperature;
@property (nonatomic, readwrite) CGFloat lowTemperature;
@property (nonatomic, readwrite) CGFloat highTemperature;

@end

@implementation CWCurrentConditions

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON
{
    CWCurrentConditions *conditions = [self new];
    conditions.conditionsDescription = JSON[@"icon"];
    conditions.temperature = [JSON[@"temperature"] floatValue];

    NSDictionary *todayForecast = [JSON[@"daily"][@"data"] firstObject];
    conditions.lowTemperature = [todayForecast[@"temperatureMin"] floatValue];
    conditions.highTemperature = [todayForecast[@"temperatureMax"] floatValue];

    return conditions;
}

@end
