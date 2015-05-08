#import "TRWeatherUpdate.h"

@interface TRWeatherUpdateCache : NSObject

- (TRWeatherUpdate *)latestWeatherUpdate;
- (BOOL)archiveWeatherUpdate:(TRWeatherUpdate *)update;

@end
