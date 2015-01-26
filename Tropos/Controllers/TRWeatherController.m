@import CoreLocation;
#import "TRWeatherController.h"
#import "TRLocationController.h"
#import "TRForecastClient.h"
#import "TRWeatherViewModel.h"
#import "TRWeatherLocation.h"
#import "TRSettingsController.h"
#import "TRWeatherStatusViewModel.h"

@interface TRWeatherController ()

@property (nonatomic, readwrite) TRWeatherStatusViewModel *statusViewModel;
@property (nonatomic, readwrite) TRWeatherViewModel *weatherViewModel;
@property (nonatomic) TRLocationController *locationController;
@property (nonatomic) TRForecastClient *forecastClient;

@property (nonatomic) TRWeatherLocation *weatherLocation;
@property (nonatomic) TRCurrentConditions *currentConditions;
@property (nonatomic) TRHistoricalConditions *yesterdaysConditions;

@end

@implementation TRWeatherController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.locationController = [TRLocationController controllerWithAuthorizationType:TRLocationAuthorizationWhenInUse authorizationChanged:^(BOOL authorized) {
        if (authorized) {
            [self updateWeather];
        }
    }];
    self.forecastClient = [TRForecastClient new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitSettingsDidChange:) name:TRSettingsDidChangeNotification object:nil];

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

    self.weatherViewModel = nil;
    [self locationUpdateWillStart];

    __weak typeof(self) weakSelf = self;
    [self.locationController updateLocationWithBlock:^(TRWeatherLocation *weatherLocation, NSError *error) {
        if (error) {
            [self updateDidFail];
            return;
        }

        weakSelf.weatherLocation = weatherLocation;
        [self conditionsUpdateWillStart];

        [self.forecastClient fetchConditionsAtLatitude:weatherLocation.coordinate.latitude longitude:weatherLocation.coordinate.longitude completion:^(TRCurrentConditions *currentConditions, TRHistoricalConditions *yesterdaysConditions) {
            typeof(self) strongSelf = weakSelf;

            strongSelf.currentConditions = currentConditions;
            strongSelf.yesterdaysConditions = yesterdaysConditions;
            strongSelf.weatherViewModel = [[TRWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];

            [strongSelf updateDidFinish];
        }];
    }];
}

#pragma mark - Private Methods

- (void)unitSettingsDidChange:(NSNotification *)notification
{
    self.weatherViewModel = [[TRWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];
}

- (void)locationUpdateWillStart
{
    self.statusViewModel = [TRWeatherStatusViewModel viewModelForStatus:TRWeatherStatusLocating weatherLocation:self.weatherLocation];
}

- (void)conditionsUpdateWillStart
{
    self.statusViewModel = [TRWeatherStatusViewModel viewModelForStatus:TRWeatherStatusUpdating weatherLocation:self.weatherLocation];
}

- (void)updateDidFinish
{
    self.statusViewModel = [TRWeatherStatusViewModel viewModelForStatus:TRWeatherStatusUpdated weatherLocation:self.weatherLocation];
}

- (void)updateDidFail
{
    self.statusViewModel = [TRWeatherStatusViewModel viewModelForStatus:TRWeatherStatusFailed weatherLocation:self.weatherLocation];
}

@end
