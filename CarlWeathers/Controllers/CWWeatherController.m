@import CoreLocation;
#import "CWWeatherController.h"
#import "CWLocationController.h"
#import "CWForecastClient.h"
#import "CWWeatherViewModel.h"
#import "CWWeatherLocation.h"
#import "CWSettingsController.h"
#import "CWWeatherStatusViewModel.h"

@interface CWWeatherController ()

@property (nonatomic, readwrite) CWWeatherStatusViewModel *statusViewModel;
@property (nonatomic, readwrite) CWWeatherViewModel *weatherViewModel;
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

    [self locationUpdateWillStart];

    __weak typeof(self) weakSelf = self;
    [self.locationController updateLocationWithBlock:^(CWWeatherLocation *weatherLocation, NSError *error) {
        if (error) {
            [self updateDidFail];
            return;
        }

        weakSelf.weatherLocation = weatherLocation;
        [self conditionsUpdateWillStart];

        [self.forecastClient fetchConditionsAtLatitude:weatherLocation.coordinate.latitude longitude:weatherLocation.coordinate.longitude completion:^(CWCurrentConditions *currentConditions, CWHistoricalConditions *yesterdaysConditions) {
            typeof(self) strongSelf = weakSelf;

            strongSelf.currentConditions = currentConditions;
            strongSelf.yesterdaysConditions = yesterdaysConditions;
            strongSelf.weatherViewModel = [[CWWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];

            [strongSelf updateDidFinish];
        }];
    }];
}

#pragma mark - Private Methods

- (void)unitSettingsDidChange:(NSNotification *)notification
{
    self.weatherViewModel = [[CWWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];
}

- (void)locationUpdateWillStart
{
    self.statusViewModel = [CWWeatherStatusViewModel viewModelForStatus:CWWeatherStatusLocating weatherLocation:self.weatherLocation];
}

- (void)conditionsUpdateWillStart
{
    self.statusViewModel = [CWWeatherStatusViewModel viewModelForStatus:CWWeatherStatusUpdating weatherLocation:self.weatherLocation];
}

- (void)updateDidFinish
{
    self.statusViewModel = [CWWeatherStatusViewModel viewModelForStatus:CWWeatherStatusUpdated weatherLocation:self.weatherLocation];
}

- (void)updateDidFail
{
    self.statusViewModel = [CWWeatherStatusViewModel viewModelForStatus:CWWeatherStatusFailed weatherLocation:self.weatherLocation];
}

@end
