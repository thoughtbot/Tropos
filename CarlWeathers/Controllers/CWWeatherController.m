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

@property (nonatomic) NSDate *weatherUpdateDate;

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

    [[self.locationController currentLocation] subscribeNext:^(id x) {
        NSLog(@"%@", x);
    } error:^(NSError *error) {
        //
    } completed:^{
        
        NSLog(@"Completed");
    }];

    __weak typeof(self) weakSelf = self;
    return;
    [self.locationController updateLocationWithBlock:^(CWWeatherLocation *weatherLocation, NSError *error) {
        if (error) {
            self.weatherStatus = CWWeatherStatusFailed;
            return;
        }

        weakSelf.weatherLocation = weatherLocation;
        self.weatherStatus = CWWeatherStatusUpdating;

        RACSignal *conditionsSignal = [[self.forecastClient fetchConditionsAtLatitude:weatherLocation.coordinate.latitude longitude:weatherLocation.coordinate.longitude] deliverOn:[RACScheduler mainThreadScheduler]];
        RACSignal *historicalConditionsSignal = [[self.forecastClient fetchHistoricalConditionsAtLatitude:weatherLocation.coordinate.latitude longitude:weatherLocation.coordinate.longitude] deliverOn:[RACScheduler mainThreadScheduler]];

        @weakify(self)
        RAC(self, weatherViewModel) = [[[RACSignal combineLatest:@[conditionsSignal, historicalConditionsSignal] reduce:^id(id first, id second) {
            return [[CWWeatherViewModel alloc] initWithCurrentConditions:first yesterdaysConditions:second];
        }] doError:^(NSError *rror) {
            @strongify(self)
            self.weatherStatus = CWWeatherStatusFailed;
        }] doCompleted:^{
            @strongify(self)
            self.weatherUpdateDate = [NSDate date];
            self.weatherStatus = CWWeatherStatusUpdated;
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
    self.statusViewModel = [CWWeatherStatusViewModel viewModelForStatus:_weatherStatus weatherLocation:self.weatherLocation date:self.weatherUpdateDate];
}

@end
