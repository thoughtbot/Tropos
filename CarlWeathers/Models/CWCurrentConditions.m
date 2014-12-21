#import <FormatterKit/TTTLocationFormatter.h>
#import "CWCurrentConditions.h"
#import "CWTemperature.h"

@interface CWCurrentConditions ()

@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, readwrite) CWTemperature *temperature;
@property (nonatomic, readwrite) CWTemperature *lowTemperature;
@property (nonatomic, readwrite) CWTemperature *highTemperature;
@property (nonatomic, readwrite) CGFloat windSpeed;
@property (nonatomic, readwrite) CGFloat windBearing;
@property (nonatomic, readwrite) CGFloat precipitationProbability;

@end

@implementation CWCurrentConditions

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON
{
    CWCurrentConditions *conditions = [self new];
    conditions.conditionsDescription = JSON[@"currently"][@"icon"];
    conditions.temperature = [CWTemperature temperatureFromNumber:JSON[@"currently"][@"temperature"]];

    NSDictionary *todayForecast = [JSON[@"daily"][@"data"] firstObject];
    conditions.lowTemperature = [CWTemperature temperatureFromNumber:todayForecast[@"temperatureMin"]];
    conditions.highTemperature = [CWTemperature temperatureFromNumber:todayForecast[@"temperatureMax"]];
    conditions.precipitationProbability = [JSON[@"currently"][@"precipitationProbability"] floatValue];
    conditions.windSpeed = [JSON[@"currently"][@"windSpeed"] floatValue];
    conditions.windBearing = [JSON[@"currently"][@"windBearing"] floatValue];

    return conditions;
}

@end
