@import CoreLocation;
#import "CWWeatherController.h"
#import "CWLocationController.h"
#import "CWForecastClient.h"
#import "CWWeatherViewModel.h"
#import "CWWeatherLocation.h"
#import "CWSettingsController.h"

@interface CWWeatherController ()

@property (nonatomic, readwrite) CWWeatherViewModel *viewModel;
@property (nonatomic) CWLocationController *locationController;
@property (nonatomic) CWForecastClient *forecastClient;

@property (nonatomic) CWWeatherLocation *weatherLocation;
@property (nonatomic) CWCurrentConditions *currentConditions;
@property (nonatomic) CWHistoricalConditions *yesterdaysConditions;

@end

@implementation CWWeatherController

#pragma mark - Initializers

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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitSettingsDidChange:) name:CWSettingsDidChangeNotification object:nil];

    return self;
}

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

#pragma mark - Public Methods

- (void)updateWeather
{
    if (self.locationController.needsAuthorization) {
        [self.locationController requestAuthorization];
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self.locationController updateLocationWithBlock:^(CWWeatherLocation *weatherLocation, NSError *error) {
        [weakSelf.forecastClient fetchConditionsAtLatitude:weatherLocation.coordinate.latitude longitude:weatherLocation.coordinate.longitude completion:^(CWCurrentConditions *currentConditions, CWHistoricalConditions *yesterdaysConditions) {
            weakSelf.weatherLocation = weatherLocation;
            weakSelf.currentConditions = currentConditions;
            weakSelf.yesterdaysConditions = yesterdaysConditions;
            [weakSelf updateViewModel];
        }];
    }];
}

#pragma mark - Private Methods

- (void)unitSettingsDidChange:(NSNotification *)notification
{
    [self updateViewModel];
}

- (void)updateViewModel
{
    self.viewModel = [[CWWeatherViewModel alloc] initWithWeatherLocation:self.weatherLocation currentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];
}

@end
