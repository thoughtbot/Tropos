@import CoreLocation;
#import "CWWeatherController.h"
#import "CWLocationController.h"
#import "CWForecastClient.h"
#import "CWWeatherViewModel.h"
#import "CWWeatherLocation.h"
#import "CWSettingsController.h"
#import "CWWeatherStatusViewModel.h"

@interface CWWeatherController ()

@property (nonatomic) CWWeatherStatus weatherStatus;
@property (nonatomic) NSTimer *statusUpdateTimer;

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


- (void)setWeatherStatus:(CWWeatherStatus)weatherStatus
{
    _weatherStatus = weatherStatus;
    [self updateStatusViewModel];

    switch (_weatherStatus) {
        case CWWeatherStatusUpdated:
            self.statusUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateStatusViewModel) userInfo:nil repeats:YES];
            break;
        default:
            [self.statusUpdateTimer invalidate];
            self.statusUpdateTimer = nil;
            break;
    }

}

#pragma mark - Public Methods

- (void)updateWeather
{
    if (self.locationController.needsAuthorization) {
        [self.locationController requestAuthorization];
        return;
    }

    self.weatherStatus = CWWeatherStatusLocating;

    __weak typeof(self) weakSelf = self;
    [self.locationController updateLocationWithBlock:^(CWWeatherLocation *weatherLocation, NSError *error) {
        if (error) {
            self.weatherStatus = CWWeatherStatusFailed;
            return;
        }

        weakSelf.weatherLocation = weatherLocation;
        self.weatherStatus = CWWeatherStatusUpdating;

        [self.forecastClient fetchConditionsAtLatitude:weatherLocation.coordinate.latitude longitude:weatherLocation.coordinate.longitude completion:^(CWCurrentConditions *currentConditions, CWHistoricalConditions *yesterdaysConditions) {
            typeof(self) strongSelf = weakSelf;

            strongSelf.currentConditions = currentConditions;
            strongSelf.yesterdaysConditions = yesterdaysConditions;
            strongSelf.weatherViewModel = [[CWWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];

            strongSelf.weatherStatus = CWWeatherStatusUpdated;
        }];
    }];
}

#pragma mark - Private Methods

- (void)unitSettingsDidChange:(NSNotification *)notification
{
    self.weatherViewModel = [[CWWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];
}

- (void)updateStatusViewModel
{
    self.statusViewModel = [CWWeatherStatusViewModel viewModelForStatus:_weatherStatus weatherLocation:self.weatherLocation];
}

@end
