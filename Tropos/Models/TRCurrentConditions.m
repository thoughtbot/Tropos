#import "TRCurrentConditions.h"
#import "TRTemperature.h"

@interface TRCurrentConditions ()

@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, readwrite) TRTemperature *temperature;
@property (nonatomic, readwrite) TRTemperature *lowTemperature;
@property (nonatomic, readwrite) TRTemperature *highTemperature;
@property (nonatomic, readwrite) CGFloat windSpeed;
@property (nonatomic, readwrite) CGFloat windBearing;
@property (nonatomic, readwrite) CGFloat precipitationProbability;
@property (nonatomic, readwrite) NSDate *date;

@end

@implementation TRCurrentConditions

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON
{
    TRCurrentConditions *conditions = [self new];
    conditions.conditionsDescription = JSON[@"currently"][@"icon"];
    conditions.temperature = [TRTemperature temperatureFromFahrenheit:JSON[@"currently"][@"temperature"]];

    NSDictionary *todayForecast = [JSON[@"daily"][@"data"] firstObject];
    conditions.lowTemperature = [TRTemperature temperatureFromFahrenheit:todayForecast[@"temperatureMin"]];
    conditions.highTemperature = [TRTemperature temperatureFromFahrenheit:todayForecast[@"temperatureMax"]];
    conditions.precipitationProbability = [JSON[@"currently"][@"precipitationProbability"] floatValue];
    conditions.windSpeed = [JSON[@"currently"][@"windSpeed"] floatValue];
    conditions.windBearing = [JSON[@"currently"][@"windBearing"] floatValue];
    conditions.date = [NSDate date];

    return conditions;
}

@end
