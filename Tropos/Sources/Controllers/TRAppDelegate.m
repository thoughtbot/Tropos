#import <HockeySDK/HockeySDK.h>
#import <TroposCore/TroposCore.h>
#import "Tropos-Swift.h"
#import "TRAppDelegate.h"
#import "TRAnalyticsController.h"
#import "TRApplicationController.h"
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

    [[TRSettingsController new] registerSettings];
    [TRAppearanceController configureAppearance];

    self.applicationController = [TRApplicationController new];

    [self.applicationController setMinimumBackgroundFetchIntervalForApplication:application];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.applicationController.rootViewController;
    [self.window makeKeyAndVisible];

    [self.applicationController updateWeather];

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self.applicationController updateWeather];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    RACSignal *signal = [self.applicationController updateWeather];

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

@end
