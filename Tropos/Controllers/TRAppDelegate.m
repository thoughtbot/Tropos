#import <HockeySDK/HockeySDK.h>
#import "TRAppDelegate.h"
#import "TRAnalyticsController.h"
#import "TRSettingsController.h"
#import "TRApplicationController.h"

#ifndef DEBUG
#import "Secrets.h"
#endif

@implementation TRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifndef DEBUG
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:TRHockeyIdentifier];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];

    [[TRAnalyticsController sharedController] install];
#endif

    [[TRSettingsController new] registerSettings];

    self.applicationController = [TRApplicationController new];
    self.window.rootViewController = self.applicationController.rootViewController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
