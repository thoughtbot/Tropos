#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "TRWeatherViewController.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ApplicationController)
@interface TRApplicationController : NSObject

@property (nonatomic) TRWeatherViewController *rootViewController;

- (RACSignal *)updateWeather;
- (RACSignal *)localWeatherNotification;
- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application
    NS_SWIFT_NAME(setMinimumBackgroundFetchInterval(for:));

@end

NS_ASSUME_NONNULL_END
