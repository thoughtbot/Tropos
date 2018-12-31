@import CoreLocation;
@import TroposCore;

#import "TRApplication.h"
#import "TRApplicationController.h"
#import "TRWeatherController.h"
#import "Tropos-Swift.h"
#import "Secrets.h"

@interface TRApplicationController ()

@property (nonatomic) TRWeatherController *weatherController;
@property (nonatomic) TRLocationController *locationController;

@end

@implementation TRApplicationController

- (instancetype)initWithLocationController:(TRLocationController *)locationController
{
    self = [super init];
    if (!self) { return nil; }

    self.weatherController = [TRWeatherController new];
    self.locationController = locationController;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.rootViewController = [storyboard instantiateInitialViewController];
    self.rootViewController.controller = self.weatherController;

    return self;
}

- (instancetype)init
{
    return [self initWithLocationController:[TRLocationController new]];
}

- (RACSignal *)updateWeather
{
    return [self.weatherController.updateWeatherCommand execute:self];
}

- (void)setMinimumBackgroundFetchIntervalForApplication:(id<TRApplication>)application
{
    if ([self.locationController authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedAlways]) {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    } else {
        [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalNever];
    }
}

@end
