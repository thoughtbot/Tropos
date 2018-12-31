@import ReactiveObjC;
@import UIKit;

@class TRLocationController;

#import "TRApplication.h"
#import "TRWeatherViewController.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ApplicationController)
@interface TRApplicationController : NSObject

- (instancetype)initWithLocationController:(TRLocationController *)locationController;

@property (nonatomic) TRWeatherViewController *rootViewController;

- (RACSignal *)updateWeather;
- (void)setMinimumBackgroundFetchIntervalForApplication:(id<TRApplication>)application
    NS_SWIFT_NAME(setMinimumBackgroundFetchInterval(for:));

@end

NS_ASSUME_NONNULL_END
