@import CoreLocation;
#import "CWWeatherController.h"
#import "CWLocationController.h"
#import "CWForecastClient.h"
#import "CWWeatherViewModel.h"
#import "CWWeatherLocation.h"

@interface CWWeatherController ()

@property (nonatomic, readwrite) CWWeatherViewModel *viewModel;
@property (nonatomic) CWLocationController *locationController;
@property (nonatomic) CWForecastClient *forecastClient;
@end

@implementation CWWeatherController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.locationController = [CWLocationController controllerWithAuthorizationType:CWLocationAuthorizationWhenInUse authorizationChanged:^(BOOL authorized) {
        if (authorized) {
            [self updateWeather];
        }
    }];
    self.forecastClient = [CWForecastClient new];

    return self;
}

- (void)updateWeather
{
    if (self.locationController.needsAuthorization) {
        [self.locationController requestAuthorization];
        return;
    }

    [self.locationController updateLocationWithBlock:^(CWWeatherLocation *weatherLocation, NSError *error) {
        CLLocationCoordinate2D coordinate = weatherLocation.coordinate;
        [self.forecastClient fetchConditionsAtLatitude:coordinate.latitude longitude:coordinate.longitude completion:^(CWCurrentConditions *currentConditions, CWHistoricalConditions *yesterdaysConditions) {
            self.viewModel = [[CWWeatherViewModel alloc] initWithWeatherLocation:weatherLocation currentConditions:currentConditions yesterdaysConditions:yesterdaysConditions];
        }];
    }];
}

@end
