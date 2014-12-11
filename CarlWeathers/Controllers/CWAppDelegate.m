#import "CWAppDelegate.h"
#import "CWForecastClient.h"

@implementation CWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CWForecastClient *client = [CWForecastClient new];
    [client fetchCurrentConditionsAtLatitude:37 longitude:-114 completion:^(CWCurrentConditions *currentConditions) {
        NSLog(@"%@", currentConditions);
    }];
    
    return YES;
}

@end
