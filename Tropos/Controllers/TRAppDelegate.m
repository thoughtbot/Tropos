#import <HockeySDK/HockeySDK.h>
#import "Tropos-Swift.h"
#import "TRAppDelegate.h"
#import "TRAnalyticsController.h"
#import "TRApplicationController.h"
#import "TRWeatherController.h"
#import "Secrets.h"

@implementation TRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([self isCurrentlyTesting]) {
        return YES;
    }

#ifndef DEBUG
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:TRHockeyIdentifier];
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    [[TRAnalyticsController sharedController] install];
#endif

    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    [[TRSettingsController new] registerSettings];

    self.applicationController = [TRApplicationController new];

    [self.applicationController setMinimumBackgroundFetchIntervalForApplication:application];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.applicationController.rootViewController;
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
{
    NSString *channel = [[NSTimeZone localTimeZone] name];
    [self.courier subscribeToChannel:channel withToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler;
{
    if (![userInfo[@"aps"][@"content-available"] isEqual: @1]) {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }

    RACSignal *notifications = [self.applicationController localWeatherNotification];

    [notifications subscribeNext:^(UILocalNotification *notification) {
        [application scheduleLocalNotification:notification];
        completionHandler(UIBackgroundFetchResultNewData);
    } error:^(NSError *error) {
        completionHandler(UIBackgroundFetchResultFailed);
    }];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    RACSignal *signal = [self.applicationController performBackgroundFetch];

    [signal subscribeNext:^(id x) {
        completionHandler(UIBackgroundFetchResultNewData);
    } error:^(NSError *error) {
        completionHandler(UIBackgroundFetchResultFailed);
    }];
}

- (BOOL)isCurrentlyTesting
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TRTesting"];
}

- (TRCourierClient *)courier;
{
    return self.applicationController.courier;
}

@end
