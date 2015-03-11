@import CoreLocation;
#import "TRWeatherViewModel.h"
#import "TRLocationController.h"
#import "TRForecastController.h"
#import "TRSettingsController.h"
#import "TRDateFormatter.h"
#import "TRWeatherUpdate.h"
#import "TRTemperatureFormatter.h"
#import "TRWindSpeedFormatter.h"
#import "TRTemperatureComparisonFormatter.h"
#import "NSMutableAttributedString+TRAttributeHelpers.h"
#import "TRGeocodeController.h"
#import "TRDailyForecast.h"
#import "TRDailyForecastViewModel.h"
#import "TRAnalyticsController.h"

@interface TRWeatherViewModel ()

@property (nonatomic, readwrite) RACCommand *updateWeatherCommand;

@property (nonatomic) TRLocationController *locationController;
@property (nonatomic) TRGeocodeController *geocodeController;
@property (nonatomic) TRForecastController *forecastController;
@property (nonatomic) TRSettingsController *settingsController;
@property (nonatomic) TRDateFormatter *dateFormatter;

@property (nonatomic) TRWeatherUpdate *weatherUpdate;
@property (nonatomic) NSError *weatherUpdateError;

@end

@implementation TRWeatherViewModel

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.locationController = [TRLocationController new];
    self.geocodeController = [TRGeocodeController new];
    self.forecastController = [TRForecastController new];
    self.settingsController = [TRSettingsController new];
    self.dateFormatter = [TRDateFormatter new];

    @weakify(self)
    self.updateWeatherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self updateWeatherSignal];
    }];

    RAC(self, weatherUpdate) = [[self.updateWeatherCommand.executionSignals switchToLatest] doNext:^(TRWeatherUpdate *weatherUpdate) {
        [[TRAnalyticsController sharedController] trackEvent:weatherUpdate];
    }];

    RAC(self, weatherUpdateError) = [self.updateWeatherCommand.errors doNext:^(NSError *error) {
        [[TRAnalyticsController sharedController] trackError:error eventName:@"Error: Weather Update"];
    }];

    return self;
}

#pragma mark - Properties

- (RACSignal *)weatherDisplayChanged
{
    return [RACSignal combineLatest:@[RACObserve(self, weatherUpdate), self.settingsController.unitSystemChanged] reduce:^id(TRWeatherUpdate *weatherUpdate) {
        return weatherUpdate;
    }];
}

- (RACSignal *)status
{
    RACSignal *updating = [[self.updateWeatherCommand.executing ignore:@NO] mapReplace:nil];
    RACSignal *success = [[RACObserve(self, weatherUpdate) ignore:nil] map:^id(TRWeatherUpdate *update) {
        return [self.dateFormatter stringFromDate:update.date];
    }];
    RACSignal *error = [[RACObserve(self, weatherUpdateError) ignore:nil] mapReplace:nil];

    return [RACSignal merge:@[updating, success, error]];
}

- (RACSignal *)locationName
{
    RACSignal *startedLocating = [[self.updateWeatherCommand.executing ignore:@NO] mapReplace:NSLocalizedString(@"Checking Weather...", nil)];
    RACSignal *updatedLocation = [RACObserve(self, weatherUpdate) map:^id(TRWeatherUpdate *update) {
        return [NSString stringWithFormat:@"%@, %@", update.city, update.state];
    }];
    RACSignal *error = [[RACObserve(self, weatherUpdateError) ignore:nil] map:^id(id value) {
        return NSLocalizedString(@"Update Failed", nil);
    }];

    return [[RACSignal merge:@[startedLocating, updatedLocation, error]] startWith:nil];
}

- (RACSignal *)conditionsImage
{
    return [[RACObserve(self, weatherUpdate) map:^id(TRWeatherUpdate *weatherUpdate) {
        if (!weatherUpdate) return nil;
        return [UIImage imageNamed:weatherUpdate.conditionsDescription];
    }] startWith:nil];
}

- (RACSignal *)conditionsDescription
{
    return [[RACObserve(self, weatherUpdate) map:^id(TRWeatherUpdate *weatherUpdate) {
        if (!weatherUpdate) return nil;
        TRTemperatureComparison comparison = [self.weatherUpdate.currentTemperature comparedTo:self.weatherUpdate.yesterdaysTemperature];
        
        NSString *adjective;
        NSString *comparisonString = [TRTemperatureComparisonFormatter localizedStringFromComparison:comparison adjective:&adjective];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comparisonString];
        [attributedString setFont:[UIFont defaultUltraLightFontOfSize:37]];
        [attributedString setTextColor:[UIColor defaultTextColor]];
        TRTemperature *difference = [self.weatherUpdate.currentTemperature temperatureDifferenceFromTemperature:self.weatherUpdate.yesterdaysTemperature];
        [attributedString setTextColor:[self colorForTemperatureComparison:comparison difference:difference.fahrenheitValue] forSubstring:adjective];
        
        return attributedString;
    }] startWith:nil];
}

- (RACSignal *)windDescription
{
    return [[[RACSignal combineLatest:@[RACObserve(self, weatherUpdate), self.settingsController.unitSystemChanged]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(TRWeatherUpdate *weatherUpdate, __unused NSNumber *unitSystem) = tuple;

        if (!weatherUpdate) return nil;
        return [TRWindSpeedFormatter localizedStringForWindSpeed:weatherUpdate.windSpeed bearing:weatherUpdate.windBearing];
    }] startWith:nil];
}

- (RACSignal *)highLowTemperatureDescription
{
    return [[[RACSignal combineLatest:@[RACObserve(self, weatherUpdate), self.settingsController.unitSystemChanged]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(TRWeatherUpdate *weatherUpdate, __unused NSNumber *unitSystem) = tuple;

        if (!weatherUpdate) return nil;
        TRTemperatureFormatter *formatter = [TRTemperatureFormatter new];
        NSString *high = [formatter stringFromTemperature:weatherUpdate.currentHigh];
        NSString *current = [formatter stringFromTemperature:weatherUpdate.currentTemperature];
        NSString *low = [formatter stringFromTemperature:weatherUpdate.currentLow];
        NSString *temperatureString = [NSString stringWithFormat:@"%@ / %@ / %@", high, current, low];



        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:temperatureString];
        TRTemperatureComparison comparison = [self.weatherUpdate.currentTemperature comparedTo:self.weatherUpdate.yesterdaysTemperature];
        TRTemperature *difference = [self.weatherUpdate.currentTemperature temperatureDifferenceFromTemperature:self.weatherUpdate.yesterdaysTemperature];

        NSRange rangeOfFirstSlash = [temperatureString rangeOfString:@"/"];
        NSRange rangeOfLastSlash = [temperatureString rangeOfString:@"/" options:NSBackwardsSearch];
        NSRange range = NSMakeRange(rangeOfFirstSlash.location + 1, rangeOfLastSlash.location - (rangeOfFirstSlash.location + 1));

        [attributedString setTextColor:[self colorForTemperatureComparison:comparison difference:difference.fahrenheitValue] forRange:range];

        return attributedString;
    }] startWith:nil];
}

- (RACSignal *)dailyForecastViewModels
{
    return [[[RACObserve(self, weatherUpdate) ignore:nil] map:^id(TRWeatherUpdate *weatherUpdate) {
        NSMutableArray *viewModels = [NSMutableArray array];
        for (TRDailyForecast *forecast in weatherUpdate.dailyForecasts) {
            TRDailyForecastViewModel *viewModel = [[TRDailyForecastViewModel alloc] initWithDailyForecast:forecast];
            [viewModels addObject:viewModel];
        }
        return [viewModels copy];
    }] startWith:nil];
}

#pragma mark - Public Methods

- (RACSignal *)updateWeatherSignal
{
    return [[[[self.locationController requestWhenInUseAuthorization] then:^RACSignal *{
        return [self.locationController updateCurrentLocation];
    }] flattenMap:^RACStream *(CLLocation *location) {
        return [self.geocodeController reverseGeocodeLocation:location];
    }] flattenMap:^RACStream *(CLPlacemark *placemark) {
        return [self.forecastController fetchWeatherUpdateForPlacemark:placemark];
    }];
}

#pragma mark - Private Methods

- (UIColor *)colorForTemperatureComparison:(TRTemperatureComparison)comparison difference:(NSInteger)difference
{
    UIColor *color;

    switch (comparison) {
        case TRTemperatureComparisonSame:
            color = [UIColor defaultTextColor];
            break;
        case TRTemperatureComparisonColder:
            color = [UIColor coldColor];
            break;
        case TRTemperatureComparisonCooler:
            color = [UIColor coolerColor];
            break;
        case TRTemperatureComparisonHotter:
            color = [UIColor hotColor];
            break;
        case TRTemperatureComparisonWarmer:
            color = [UIColor warmerColor];
            break;
    }

    if (comparison == TRTemperatureComparisonCooler || comparison == TRTemperatureComparisonWarmer) {
        CGFloat amount = MIN(ABS(difference), 10) / 10.0f;
        CGFloat lighterAmount = 1 - amount;

        if (lighterAmount > 0.80) lighterAmount = 0.80f;

        color = [color lighterColorByAmount:lighterAmount];
    }

    return color;
}

@end
