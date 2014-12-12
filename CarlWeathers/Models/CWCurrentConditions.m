#import "CWCurrentConditions.h"

@interface CWCurrentConditions ()

@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, readwrite) NSString *temperature;
@property (nonatomic, readwrite) CGFloat lowTemperature;
@property (nonatomic, readwrite) CGFloat highTemperature;

@end

@implementation CWCurrentConditions

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON
{
    CWCurrentConditions *conditions = [self new];
    conditions.conditionsDescription = JSON[@"icon"];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    NSString *temperature = [numberFormatter stringFromNumber:JSON[@"currently"][@"temperature"]];
    conditions.temperature = [NSString stringWithFormat:@"%@°", temperature];

    NSDictionary *todayForecast = [JSON[@"daily"][@"data"] firstObject];
    conditions.lowTemperature = [todayForecast[@"temperatureMin"] floatValue];
    conditions.highTemperature = [todayForecast[@"temperatureMax"] floatValue];

    return conditions;
}

@end
