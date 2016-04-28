#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "TRWeatherViewController.h"

@class TRCourierClient;

@interface TRApplicationController : NSObject

@property (nonatomic) TRWeatherViewController *rootViewController;
@property (nonatomic) TRCourierClient *courier;

- (RACSignal *)performBackgroundFetch;
- (RACSignal *)localWeatherNotification;
- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application;

@end
