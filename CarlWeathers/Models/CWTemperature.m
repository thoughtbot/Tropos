#import "CWTemperature.h"
#import "NSNumber+CWRoundedNumber.h"

@interface CWTemperature ()

@property (nonatomic) NSNumber *temperatureNumber;

@end

@implementation CWTemperature

#pragma mark - Initialization

+ (instancetype)temperatureFromNumber:(NSNumber *)number
{
    return [[self alloc] initWithNumber:number];
}

- (instancetype)initWithNumber:(NSNumber *)number
{
    self = [super init];
    if (!self) return nil;

    self.temperatureNumber = [number roundedNumber];

    return self;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [self.temperatureNumber description];
}

#pragma mark - Public Methods

- (CWTemperatureComparison)comparedTo:(CWTemperature *)comparedTemperature
{
    NSInteger temperatureDifference = [self differenceFromTemperature:comparedTemperature];

    if (temperatureDifference >= 10) {
        return CWTemperatureComparisonHotter;
    } else if (temperatureDifference > 0) {
        return CWTemperatureComparisonWarmer;
    } else if (temperatureDifference == 0) {
        return CWTemperatureComparisonSame;
    } else if (temperatureDifference > -10) {
        return CWTemperatureComparisonCooler;
    } else {
        return CWTemperatureComparisonColder;
    }
}

- (NSInteger)differenceFromTemperature:(CWTemperature *)comparedTemperature
{
    return self.temperatureNumber.integerValue - comparedTemperature.temperatureNumber.integerValue;
}

@end
