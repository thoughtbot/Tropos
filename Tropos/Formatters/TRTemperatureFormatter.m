#import "TRTemperatureFormatter.h"
#import "TRTemperature.h"
#import "TRSettingsController.h"

@implementation TRTemperatureFormatter

- (NSString *)stringFromTemperature:(TRTemperature *)temperature
{
    BOOL usesMetricSystem = [[TRSettingsController new] unitSystem] == TRUnitSystemMetric;
    CGFloat temperatureValue = usesMetricSystem? temperature.celsiusValue : temperature.fahrenheitValue;
    return [NSString stringWithFormat:@"%.f°", temperatureValue];
}

@end
