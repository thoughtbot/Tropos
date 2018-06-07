@import CoreLocation;
#import "CLLocation+TRRecentLocation.h"

static NSTimeInterval const TRRecentLocationMaximumElapsedTimeInterval = 5;

@implementation CLLocation (TRRecentLocation)

- (BOOL)isStale
{
    return [self elapsedTimeInterval] > TRRecentLocationMaximumElapsedTimeInterval;
}

- (NSTimeInterval)elapsedTimeInterval
{
    return [[NSDate date] timeIntervalSinceDate:self.timestamp];
}

@end
