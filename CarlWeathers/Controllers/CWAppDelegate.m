#import <HockeySDK/HockeySDK.h>
#import "CWAppDelegate.h"

@implementation CWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"92f4164a0e066dfb541c8b9867fb8ebd"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[[BITHockeyManager sharedHockeyManager] authenticator] authenticateInstallation];

    return YES;
}

@end
