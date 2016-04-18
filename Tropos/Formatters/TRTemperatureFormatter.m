#import "TRTemperatureFormatter.h"
#import "Tropos-Swift.h"

@implementation TRTemperatureFormatter

- (NSString *)stringFromTemperature:(Temperature *)temperature
{
    BOOL usesMetricSystem = [[TRSettingsController new] unitSystem] == TRUnitSystemMetric;
    CGFloat temperatureValue = usesMetricSystem? temperature.celsiusValue : temperature.fahrenheitValue;
    return [NSString stringWithFormat:@"%.f°", temperatureValue];
}

@end
