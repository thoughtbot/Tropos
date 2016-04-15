#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TRWeatherViewController.h"

@interface TRApplicationController : NSObject

@property (nonatomic) TRWeatherViewController *rootViewController;

- (RACSignal *)performBackgroundFetch;
- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application;

@end
