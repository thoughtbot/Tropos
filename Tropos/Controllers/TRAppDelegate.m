#import "TRAppDelegate.h"
#import "TRSettingsController.h"

@implementation TRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[TRSettingsController new] registerSettings];
    return YES;
}

@end
