#import "CWTemperatureFormatter.h"
#import "CWTemperature.h"

@implementation CWTemperatureFormatter

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.usesMetricSystem = YES;

    return self;
}

- (NSString *)stringFromTemperature:(CWTemperature *)temperature
{
    CGFloat temperatureValue = self.usesMetricSystem? temperature.celsiusValue : temperature.fahrenheitValue;
    return [NSString stringWithFormat:@"%.f°", temperatureValue];
}

@end
