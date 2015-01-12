#import "CWTemperature.h"
#import "NSNumber+CWRoundedNumber.h"

NSInteger CWConvertFahrenheitToCelsius(NSInteger fahrenheit) {
    return (NSInteger)round((fahrenheit - 32) * 5 / 9);
}

@interface CWTemperature ()

@property (nonatomic, readwrite) NSInteger fahrenheitValue;

@end

@implementation CWTemperature

#pragma mark - Class Methods

+ (instancetype)temperatureFromFahrenheit:(NSNumber *)number
{
    return [[self alloc] initWithFahrenheit:number];
}

#pragma mark - Initialization

- (instancetype)initWithFahrenheit:(NSNumber *)number
{
    self = [super init];
    if (!self) return nil;

    self.fahrenheitValue = [number integerValue];

    return self;
}

#pragma mark - Public Methods

- (NSInteger)celsiusValue
{
    return CWConvertFahrenheitToCelsius(self.fahrenheitValue);
}

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
    return self.fahrenheitValue - comparedTemperature.fahrenheitValue;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"Fahrenheit: %ld°\nCelsius: %ld°", (long)self.fahrenheitValue, (long)self.celsiusValue];
}

@end
