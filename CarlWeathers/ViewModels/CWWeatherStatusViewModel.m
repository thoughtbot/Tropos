#import "CWWeatherStatusViewModel.h"
#import "CWWeatherLocation.h"
#import "CWDateFormatter.h"

@interface CWWeatherStatusViewModel ()

@property (nonatomic) CWWeatherStatus weatherStatus;
@property (nonatomic) CWWeatherLocation *weatherLocation;
@property (nonatomic) NSDate *updatedDate;

@end

@implementation CWWeatherStatusViewModel

+ (instancetype)viewModelForStatus:(CWWeatherStatus)status weatherLocation:(CWWeatherLocation *)weatherLocation date:(NSDate *)date
{
    return [[self alloc] initWithStatus:status weatherLocation:weatherLocation date:date];
}

- (instancetype)initWithStatus:(CWWeatherStatus)weatherStatus weatherLocation:(CWWeatherLocation *)weatherLocation date:(NSDate *)date
{
    self = [super init];
    if (!self) return nil;

    self.weatherStatus = weatherStatus;
    self.weatherLocation = weatherLocation;
    self.updatedDate = date;

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
            statusString = [NSString localizedStringWithFormat:@"Updated %@", [self lastUpdatedString]];
            break;
        case CWWeatherStatusFailed:
            statusString = NSLocalizedString(@"Error updating conditions", nil);
            break;
    }

    return statusString;
}

- (NSString *)lastUpdatedString
{
    CWDateFormatter *dateFormatter = [CWDateFormatter new];
    return [dateFormatter stringFromDate:self.updatedDate];
}

@end
