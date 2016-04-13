@import CoreLocation;
#import "TRWeatherUpdate+Analytics.h"

@implementation TRWeatherUpdate (TRAnalytics)

- (NSString *)eventName
{
    return @"Weather Update";
}

- (NSDictionary *)eventProperties
{
    return (@{
              @"Latitude": [self analyticsLatitude],
              @"Longitude": [self analyticsLongitude],
              @"City": self.city,
              @"State": self.state,
              @"Temperature": @(self.currentTemperature.fahrenheitValue),
              @"Low Temperature": @(self.currentLow.fahrenheitValue),
              @"High Temperature": @(self.currentHigh.fahrenheitValue),
              @"Wind Speed": @(self.windSpeed),
              @"Wind Bearing": @(self.windBearing),
              @"Update Date": self.date
              });
}

#pragma mark - Analytics Formatters

- (NSNumber *)analyticsLatitude
{
    return [self anonymizeLocationDegrees:self.placemark.location.coordinate.latitude];
}

- (NSNumber *)analyticsLongitude
{
    return [self anonymizeLocationDegrees:self.placemark.location.coordinate.longitude];
}

- (NSNumber *)anonymizeLocationDegrees:(double)degrees
{
    return @(round(degrees * 100) / 100);
}

@end
