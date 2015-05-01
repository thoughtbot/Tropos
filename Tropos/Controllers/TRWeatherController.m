@import CoreLocation;
#import "TRWeatherController.h"
#import "TRWeatherUpdate.h"
#import "TRLocationController.h"
#import "TRForecastController.h"
#import "TRSettingsController.h"
#import "TRGeocodeController.h"
#import "TRDailyForecastViewModel.h"
#import "TRAnalyticsController.h"
#import "TRWeatherViewModel.h"

@interface TRWeatherController ()

@property (nonatomic, readwrite) RACCommand *updateWeatherCommand;

@property (nonatomic) TRLocationController *locationController;
@property (nonatomic) TRGeocodeController *geocodeController;
@property (nonatomic) TRForecastController *forecastController;
@property (nonatomic) TRSettingsController *settingsController;

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

    @weakify(self)
    self.updateWeatherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[[self.locationController requestWhenInUseAuthorization] then:^RACSignal *{
            return [self.locationController updateCurrentLocation];
        }] flattenMap:^RACStream *(CLLocation *location) {
            return [self.geocodeController reverseGeocodeLocation:location];
        }] flattenMap:^RACStream *(CLPlacemark *placemark) {
            return [self.forecastController fetchWeatherUpdateForPlacemark:placemark];
        }];
    }];

    RAC(self, viewModel) = [[[self.updateWeatherCommand.executionSignals switchToLatest] doNext:^(TRWeatherUpdate *update) {
        [[TRAnalyticsController sharedController] trackEvent:update];
    }] map:^id(TRWeatherUpdate *update) {
        return [[TRWeatherViewModel alloc] initWithWeatherUpdate:update];
    }];

    RAC(self, weatherUpdateError) = [self.updateWeatherCommand.errors doNext:^(NSError *error) {
        [[TRAnalyticsController sharedController] trackError:error eventName:@"Error: Weather Update"];
    }];

    return self;
}

#pragma mark - Properties

- (RACSignal *)status
{
    RACSignal *updating = [[self.updateWeatherCommand.executing ignore:@NO] mapReplace:nil];
    RACSignal *success = [RACObserve(self, viewModel.updatedDateString) ignore:nil];
    RACSignal *error = [[RACObserve(self, weatherUpdateError) ignore:nil] mapReplace:nil];

    return [RACSignal merge:@[updating, success, error]];
}

- (RACSignal *)locationName
{
    RACSignal *startedLocating = [[self.updateWeatherCommand.executing ignore:@NO] mapReplace:NSLocalizedString(@"Checking Weather...", nil)];
    RACSignal *updatedLocation = RACObserve(self, viewModel.locationName);
    RACSignal *error = [[RACObserve(self, weatherUpdateError) ignore:nil] map:^id(id value) {
        return NSLocalizedString(@"Update Failed", nil);
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
    return [[RACObserve(self, viewModel.windDescription) combineLatestWith:self.settingsController.unitSystemChanged] map:^id(id value) {
        return self.viewModel.windDescription;
    }];
}

- (RACSignal *)highLowTemperatureDescription
{
    return [[RACObserve(self, viewModel.temperatureDescription) combineLatestWith:self.settingsController.unitSystemChanged] map:^id(RACTuple *tuple) {
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
