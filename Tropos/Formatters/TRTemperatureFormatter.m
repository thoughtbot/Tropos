#import "TRTemperatureFormatter.h"
#import "TRTemperature.h"

@implementation TRTemperatureFormatter

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.usesMetricSystem = YES;

    return self;
}

- (NSString *)stringFromTemperature:(TRTemperature *)temperature
{
    CGFloat temperatureValue = self.usesMetricSystem? temperature.celsiusValue : temperature.fahrenheitValue;
    return [NSString stringWithFormat:@"%.f°", temperatureValue];
}

@end
