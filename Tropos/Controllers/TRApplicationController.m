@import CoreLocation;
#import "TRApplicationController.h"
#import "TRWeatherController.h"
#import "TRLocationController.h"
#import "Tropos-Swift.h"
#import "Secrets.h"

@interface TRApplicationController ()

@property (nonatomic) TRWeatherController *weatherController;
@property (nonatomic) TRLocationController *locationController;

@end

@implementation TRApplicationController

- (instancetype)init
{
    self = [super init];
    if (!self) { return nil; }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.rootViewController = [storyboard instantiateInitialViewController];

    self.weatherController = [TRWeatherController new];
    self.locationController = [TRLocationController new];
    self.courier = [[TRCourierClient alloc] initWithApiToken: TRCourierAPIToken];

    return self;
}

- (RACSignal *)performBackgroundFetch
{
    return [self.weatherController.updateWeatherCommand execute:self];
}

- (RACSignal *)localWeatherNotification
{
    RACSignal *updatedConditions = self.weatherController.conditionsDescription;
    return [updatedConditions map:^(NSAttributedString *conditions) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate distantPast];
        notification.alertTitle = NSLocalizedString(@"TodayWeatherForecast", "");
        notification.alertBody = conditions.string;
        return notification;
    }];
}

- (void)setMinimumBackgroundFetchIntervalForApplication:(UIApplication *)application
{
    if ([self.locationController authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedAlways]) {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    } else {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    }
}

- (void)subscribeToNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *formerChannelKey = @"CourierChannel";

    NSString *channel = [[NSTimeZone localTimeZone] name];

    NSString *formerChannel = [userDefaults stringForKey:formerChannelKey];
    if (formerChannel && ![channel isEqualToString:formerChannel]) {
        [self.courier unsubscribeFromChannel:formerChannel];
    }
    [self.courier subscribeToChannel:channel withToken:deviceToken];

    [userDefaults setObject:channel forKey:formerChannelKey];
}

@end
