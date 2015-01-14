#import "TRWeatherStatusViewModel.h"
#import "TRWeatherLocation.h"

@interface TRWeatherStatusViewModel ()

@property (nonatomic) TRWeatherStatus weatherStatus;
@property (nonatomic) TRWeatherLocation *weatherLocation;

@end

@implementation TRWeatherStatusViewModel

+ (instancetype)viewModelForStatus:(TRWeatherStatus)status weatherLocation:(TRWeatherLocation *)weatherLocation
{
    return [[self alloc] initWithStatus:status weatherLocation:weatherLocation];
}

- (instancetype)initWithStatus:(TRWeatherStatus)weatherStatus weatherLocation:(TRWeatherLocation *)weatherLocation
{
    self = [super init];
    if (!self) return nil;

    self.weatherStatus = weatherStatus;
    self.weatherLocation = weatherLocation;

    return self;
}

- (NSString *)location
{
    if (!self.weatherLocation) {
        return nil;
    }
    
    return [NSString stringWithFormat:@"%@, %@", self.weatherLocation.city, self.weatherLocation.state];
}

- (NSString *)status
{
    NSString *statusString;

    switch (self.weatherStatus) {
        case TRWeatherStatusLocating:
            statusString = NSLocalizedString(@"Locating...", nil);
            break;
        case TRWeatherStatusUpdating:
            statusString = NSLocalizedString(@"Getting conditions...", nil);
            break;
        case TRWeatherStatusUpdated:
            statusString = [NSString localizedStringWithFormat:@"Updated: %@", [self lastUpdatedString]];
            break;
        case TRWeatherStatusFailed:
            statusString = NSLocalizedString(@"Error updating conditions", nil);
            break;
    }

    return statusString;
}

- (NSString *)lastUpdatedString
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return [dateFormatter stringFromDate:[NSDate date]];
}

@end
