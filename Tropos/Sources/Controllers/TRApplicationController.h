#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "TRWeatherViewController.h"

@class TRCourierClient;

@interface TRApplicationController : NSObject

@property (nonatomic) TRWeatherViewController *rootViewController;
@property (nonatomic) TRCourierClient *courier;

- (RACSignal *)updateWeather;
- (RACSignal *)localWeatherNotification;
- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application;

- (void)subscribeToNotificationsWithDeviceToken:(NSData *)deviceToken;

@end
