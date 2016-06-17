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

    self.weatherController = [TRWeatherController new];
    self.locationController = [TRLocationController new];
    self.courier = [[TRCourierClient alloc] initWithApiToken: TRCourierAPIToken];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.rootViewController = [storyboard instantiateInitialViewController];
    self.rootViewController.controller = self.weatherController;

    return self;
}

- (RACSignal *)updateWeather
{
    return [self.weatherController.updateWeatherCommand execute:self];
}

- (RACSignal *)localWeatherNotification
{
    RACSignal *conditionsDescription = self.weatherController.conditionsDescription;

    RACSignal *updatedConditions = [self.updateWeather then:^RACSignal *{
        return [conditionsDescription take:1];
    }];

    return [updatedConditions map:^(NSAttributedString *conditions) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate distantPast];
        notification.alertTitle = @"Tropos";
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

    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *channel = [TRCourierClient channelNameForTimeZone:timeZone];

    NSString *formerChannel = [userDefaults stringForKey:formerChannelKey];
    if (formerChannel && ![channel isEqualToString:formerChannel]) {
        NSLog(@"unsubscribe from channel: %@", formerChannel);
        [self.courier unsubscribeFromChannel:formerChannel];
    }

    NSLog(@"subscribe to channel: %@", channel);
    [self.courier subscribeToChannel:channel withToken:deviceToken];

    [userDefaults setObject:channel forKey:formerChannelKey];
}

@end
