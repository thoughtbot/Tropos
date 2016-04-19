#import "TRWindSpeedFormatter.h"
#import "TRBearingFormatter.h"
#import "Tropos-Swift.h"

@implementation TRWindSpeedFormatter

static inline double TRKilometersPerHourFromMilesPerHour(double milesPerHour) {
    return milesPerHour * 1.60934f;
}

static inline double TRMetersPerSecondFromMilesPerHour(double milesPerHour) {
    return milesPerHour * 0.44704f;
}

+ (NSString *)localizedStringForWindSpeed:(double)speed bearing:(double)bearing
{
    NSString *abbreviatedSpeedUnit = @"mph";

    if ([[TRSettingsController new] unitSystem] == TRUnitSystemMetric) {
        NSString *currentCountryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];

        if ([currentCountryCode isEqualToString:@"CA"]) {
            abbreviatedSpeedUnit = @"km/h";
            speed = TRKilometersPerHourFromMilesPerHour(speed);
        } else {
            abbreviatedSpeedUnit = @"m/s";
            speed = TRMetersPerSecondFromMilesPerHour(speed);
        }
    }

    NSString *bearingAbbreviation = [TRBearingFormatter abbreviatedCardinalDirectionStringFromBearing:bearing];

    return [NSString stringWithFormat:@"%.0f %@ %@", speed, abbreviatedSpeedUnit, bearingAbbreviation];
}

@end
