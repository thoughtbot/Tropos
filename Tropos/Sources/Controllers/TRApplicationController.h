#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "TRWeatherViewController.h"

@interface TRApplicationController : NSObject

@property (nonatomic) TRWeatherViewController *rootViewController;

- (RACSignal *)updateWeather;
- (RACSignal *)localWeatherNotification;
- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application;

@end
