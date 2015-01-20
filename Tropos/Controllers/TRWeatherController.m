@import CoreLocation;
#import "TRWeatherController.h"
#import "TRLocationController.h"
#import "TRForecastClient.h"
#import "TRWeatherViewModel.h"
#import "TRWeatherLocation.h"
#import "TRSettingsController.h"
#import "TRDateFormatter.h"

typedef NS_ENUM(NSUInteger, TRWeatherUpdateStatus) {
    TRWeatherUpdateStatusUpdating,
    TRWeatherUpdateStatusFinished,
    TRWeatherUpdateStatusFailed
};

@interface TRWeatherController ()

@property (nonatomic, readwrite) TRWeatherViewModel *weatherViewModel;

@property (nonatomic) TRLocationController *locationController;
@property (nonatomic) TRForecastClient *forecastClient;
@property (nonatomic) TRDateFormatter *dateFormatter;

@property (nonatomic) TRWeatherLocation *weatherLocation;
@property (nonatomic) TRCurrentConditions *currentConditions;
@property (nonatomic) TRHistoricalConditions *yesterdaysConditions;
@property (nonatomic) TRWeatherUpdateStatus updateStatus;
@property (nonatomic) NSDate *lastUpdatedDate;

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
    self.dateFormatter = [TRDateFormatter new];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unitSettingsDidChange:) name:TRSettingsDidChangeNotification object:nil];

    return self;
}

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSUserDefaultsDidChangeNotification object:nil];
}

#pragma mark - Properties

- (RACSignal *)status
{
    RACSignal *interval = [RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]];

    return [[RACSignal combineLatest:@[interval, RACObserve(self, updateStatus), RACObserve(self, lastUpdatedDate)] reduce:^id(id _, NSNumber *updateStatus, NSDate *date) {
        return [self statusStringForUpdateStatus:updateStatus.unsignedIntegerValue lastUpdatedDate:date];
    }] distinctUntilChanged];
}

- (RACSignal *)locationName
{
    return [RACObserve(self, weatherLocation) map:^id(TRWeatherLocation *weatherLocation) {
        return [NSString stringWithFormat:@"%@, %@", weatherLocation.city, weatherLocation.state];
    }];
}

#pragma mark - Public Methods

- (void)updateWeather
{
    if (self.locationController.needsAuthorization) {
        [self.locationController requestAuthorization];
        return;
    }

    self.updateStatus = TRWeatherUpdateStatusUpdating;

    __weak typeof(self) weakSelf = self;
    [self.locationController updateLocationWithBlock:^(TRWeatherLocation *weatherLocation, NSError *error) {
        if (error) {
            self.updateStatus = TRWeatherUpdateStatusFailed;
            return;
        }

        weakSelf.weatherLocation = weatherLocation;

        [self.forecastClient fetchConditionsAtLatitude:weatherLocation.coordinate.latitude longitude:weatherLocation.coordinate.longitude completion:^(TRCurrentConditions *currentConditions, TRHistoricalConditions *yesterdaysConditions) {
            typeof(self) strongSelf = weakSelf;

            strongSelf.currentConditions = currentConditions;
            strongSelf.yesterdaysConditions = yesterdaysConditions;
            strongSelf.weatherViewModel = [[TRWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];
            strongSelf.lastUpdatedDate = [NSDate date];
            strongSelf.updateStatus = TRWeatherUpdateStatusFinished;
        }];
    }];
}

#pragma mark - Private Methods

- (void)unitSettingsDidChange:(NSNotification *)notification
{
    self.weatherViewModel = [[TRWeatherViewModel alloc] initWithCurrentConditions:self.currentConditions yesterdaysConditions:self.yesterdaysConditions];
}

- (NSString *)statusStringForUpdateStatus:(TRWeatherUpdateStatus)status lastUpdatedDate:(NSDate *)date
{
    switch (status) {
        case TRWeatherUpdateStatusUpdating:
            return NSLocalizedString(@"Updating", nil);
        case TRWeatherUpdateStatusFinished:
            return [NSString localizedStringWithFormat:@"Updated %@", [self.dateFormatter stringFromDate:date]];
        case TRWeatherUpdateStatusFailed:
            return NSLocalizedString(@"Update Failed", nil);
    }
}

@end
