#import "CWWeatherStatusViewModel.h"
#import "CWWeatherLocation.h"

@interface CWWeatherStatusViewModel ()

@property (nonatomic) CWWeatherStatus weatherStatus;
@property (nonatomic) CWWeatherLocation *weatherLocation;

@end

@implementation CWWeatherStatusViewModel

+ (instancetype)viewModelForStatus:(CWWeatherStatus)status weatherLocation:(CWWeatherLocation *)weatherLocation
{
    return [[self alloc] initWithStatus:status weatherLocation:weatherLocation];
}

- (instancetype)initWithStatus:(CWWeatherStatus)weatherStatus weatherLocation:(CWWeatherLocation *)weatherLocation
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
        case CWWeatherStatusLocating:
            statusString = NSLocalizedString(@"Locating...", nil);
            break;
        case CWWeatherStatusUpdating:
            statusString = NSLocalizedString(@"Getting conditions...", nil);
            break;
        case CWWeatherStatusUpdated:
            statusString = [NSString localizedStringWithFormat:@"Updated: %@", [self lastUpdatedString]];
            break;
        case CWWeatherStatusFailed:
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
