#import "CWTemperature.h"
#import "NSNumber+CWRoundedNumber.h"

@interface CWTemperature ()

@property (nonatomic) NSNumber *temperature;

@end

@implementation CWTemperature

+ (instancetype)temperatureFromNumber:(NSNumber *)number
{
    return [[self alloc] initWithNumber:number];
}

- (instancetype)initWithNumber:(NSNumber *)number
{
    self = [super init];
    if (!self) return nil;

    self.temperature = [number roundedNumber];

    return self;
}

- (NSString *)stringValue
{
    return [self.temperature.stringValue stringByAppendingString:@"°"];
}

- (CWTemperatureComparison)compare:(CWTemperature *)comparedTemperature
{
    NSInteger temperature = self.temperature.integerValue;
    NSInteger otherTemperature = comparedTemperature.temperature.integerValue;
    NSInteger temperatureChange = temperature - otherTemperature;
    if (temperatureChange >= 10) {
        return CWTemperatureComparisonHotter;
    } else if (temperatureChange > 0) {
        return CWTemperatureComparisonWarmer;
    } else if (temperatureChange <= -10) {
        return CWTemperatureComparisonColder;
    } else if (temperatureChange < 0) {
        return CWTemperatureComparisonCooler;
    } else {
        return CWTemperatureComparisonSame;
    }
}

@end
