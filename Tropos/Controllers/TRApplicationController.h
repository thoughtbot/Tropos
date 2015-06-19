#import "TRWeatherViewController.h"

@interface TRApplicationController : NSObject

@property (nonatomic) TRWeatherViewController *rootViewController;

- (RACSignal *)performBackgroundFetch;
- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application;

@end
