#import "CWAppDelegate.h"
#import "CWSettingsController.h"

@implementation CWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[CWSettingsController new] registerSettings];
    return YES;
}

@end
