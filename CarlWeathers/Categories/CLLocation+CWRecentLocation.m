@import CoreLocation;
#import "CLLocation+CWRecentLocation.h"

static NSTimeInterval const CWRecentLocationMaximumElapsedTimeInterval = 5;

@implementation CLLocation (CWRecentLocation)

- (BOOL)isStale
{
    return [self elapsedTimeInterval] > CWRecentLocationMaximumElapsedTimeInterval;
}

- (NSTimeInterval)elapsedTimeInterval
{
    return [[NSDate date] timeIntervalSinceDate:self.timestamp];
}

@end
