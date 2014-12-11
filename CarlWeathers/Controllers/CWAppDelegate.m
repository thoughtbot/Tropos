//
//  CWAppDelegate.m
//  CarlWeathers
//
//  Created by Mark Adams on 12/11/14
//  Copyright (c) 2014 thoughtbot. All rights reserved.
//

#import "CWAppDelegate.h"
#import "CWForecastClient.h"

@implementation CWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CWForecastClient *client = [CWForecastClient new];
    [client fetchCurrentConditionsAtLatitude:37 longitude:-114 completion:^(id currentConditions) {
        NSLog(@"%@", currentConditions);
    }];
    
    return YES;
}

@end
