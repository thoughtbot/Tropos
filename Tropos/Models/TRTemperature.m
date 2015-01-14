#import "TRTemperature.h"
#import "NSNumber+TRRoundedNumber.h"

NSInteger TRConvertFahrenheitToCelsius(NSInteger fahrenheit) {
    return (NSInteger)round((fahrenheit - 32) * 5 / 9);
}

@interface TRTemperature ()

@property (nonatomic, readwrite) NSInteger fahrenheitValue;

@end

@implementation TRTemperature

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
    return TRConvertFahrenheitToCelsius(self.fahrenheitValue);
}

- (TRTemperatureComparison)comparedTo:(TRTemperature *)comparedTemperature
{
    CGFloat temperatureDifference = [self differenceFromTemperature:comparedTemperature];

    if (temperatureDifference >= 10) {
        return TRTemperatureComparisonHotter;
    } else if (temperatureDifference > 0) {
        return TRTemperatureComparisonWarmer;
    } else if (temperatureDifference == 0) {
        return TRTemperatureComparisonSame;
    } else if (temperatureDifference > -10) {
        return TRTemperatureComparisonCooler;
    } else {
        return TRTemperatureComparisonColder;
    }
}

- (CGFloat)differenceFromTemperature:(TRTemperature *)comparedTemperature
{
    return self.fahrenheitValue - comparedTemperature.fahrenheitValue;
}

#pragma mark - NSObject

- (NSString *)description
{
    return [NSString stringWithFormat:@"Fahrenheit: %ld°\nCelsius: %ld°", (long)self.fahrenheitValue, (long)self.celsiusValue];
}

@end
