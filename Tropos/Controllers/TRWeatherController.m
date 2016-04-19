@import CoreLocation;
#import "RACSignal+TROperators.h"
#import "Tropos-Swift.h"
#import "TRWeatherController.h"
#import "TRWeatherUpdate+Analytics.h"
#import "TRLocationController.h"
#import "TRForecastController.h"
#import "TRSettingsController+TRObservation.h"
#import "TRGeocodeController.h"
#import "TRAnalyticsController.h"

@interface TRWeatherController ()

@property (nonatomic, readwrite) RACCommand *updateWeatherCommand;

@property (nonatomic) TRLocationController *locationController;
@property (nonatomic) TRGeocodeController *geocodeController;
@property (nonatomic) TRForecastController *forecastController;
@property (nonatomic) TRSettingsController *settingsController;
@property (nonatomic) RACSignal *unitSystemChanged;

@property (nonatomic) TRWeatherViewModel *viewModel;
@property (nonatomic) NSError *weatherUpdateError;

@end

@implementation TRWeatherController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.locationController = [TRLocationController new];
    self.geocodeController = [TRGeocodeController new];
    self.forecastController = [TRForecastController new];
    self.settingsController = [TRSettingsController new];
    self.unitSystemChanged = [[self.settingsController unitSystemChanged] replayLastLazily];

    @weakify(self)
    self.updateWeatherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[[self.locationController requestAlwaysAuthorization] then:^RACSignal *{
            return [self.locationController updateCurrentLocation];
        }] flattenMap:^RACStream *(CLLocation *location) {
            return [self.geocodeController reverseGeocodeLocation:location];
        }] flattenMap:^RACStream *(CLPlacemark *placemark) {
            return [self.forecastController fetchWeatherUpdateForPlacemark:placemark];
        }];
    }];

    RAC(self, viewModel) = [[self latestWeatherUpdates] map:^id(TRWeatherUpdate *update) {
        return [[TRWeatherViewModel alloc] initWithWeatherUpdate:update];
    }];

    RAC(self, weatherUpdateError) = [self.updateWeatherCommand.errors doNext:^(NSError *error) {
        [[TRAnalyticsController sharedController] trackError:error eventName:@"Error: Weather Update"];
    }];

    [[self latestWeatherUpdates] subscribeNext:^(TRWeatherUpdate *update) {
        [[TRAnalyticsController sharedController] trackEvent:update];
        [[TRWeatherUpdateCache new] archiveWeatherUpdate:update];
    }];

    return self;
}

- (RACSignal *)latestWeatherUpdates
{
    TRWeatherUpdate *cachedUpdate = [[TRWeatherUpdateCache new] latestWeatherUpdate];
    RACSignal *weatherUpdates = [self.updateWeatherCommand.executionSignals startWith:[RACSignal return:cachedUpdate]];

    return [[weatherUpdates switchToLatest] filter:^BOOL(TRWeatherUpdate *update) {
        return update != nil;
    }];
}

#pragma mark - Properties

- (RACSignal *)status
{
    RACSignal *initialValue = [RACSignal return:nil];
    RACSignal *success = [RACObserve(self, viewModel.updatedDateString) ignore:nil];
    RACSignal *error = [[RACObserve(self, weatherUpdateError) ignore:nil] mapReplace:nil];

    return [RACSignal merge:@[initialValue, success, error]];
}

- (RACSignal *)locationName
{
    RACSignal *startedLocating = [[self.updateWeatherCommand.executing ignore:@NO] mapReplace:NSLocalizedString(@"CheckingWeather", nil)];
    RACSignal *updatedLocation = RACObserve(self, viewModel.locationName);
    RACSignal *error = [[RACObserve(self, weatherUpdateError) ignore:nil] map:^id(id value) {
        return NSLocalizedString(@"UpdateFailed", nil);
    }];

    return [[RACSignal merge:@[startedLocating, updatedLocation, error]] startWith:nil];
}

- (RACSignal *)conditionsImage
{
    return RACObserve(self, viewModel.conditionsImage);
}

- (RACSignal *)conditionsDescription
{
    return RACObserve(self, viewModel.conditionsDescription);
}

- (RACSignal *)windDescription
{
    return [[RACObserve(self, viewModel.windDescription) combineLatestWith:self.unitSystemChanged] map:^id(id value) {
        return self.viewModel.windDescription;
    }];
}

- (RACSignal *)highLowTemperatureDescription
{
    return [[RACObserve(self, viewModel.temperatureDescription) combineLatestWith:self.unitSystemChanged] map:^id(RACTuple *tuple) {
        return self.viewModel.temperatureDescription;
    }];
}

- (RACSignal *)dailyForecastViewModels
{
    return RACObserve(self, viewModel.dailyForecasts);
}

- (RACSignal *)precipitationDescription
{
    return RACObserve(self, viewModel.precipitationDescription);
}

@end
