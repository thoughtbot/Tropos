@import CoreLocation;
#import "TRWeatherViewModel.h"
#import "TRLocationController.h"
#import "TRForecastController.h"
#import "TRSettingsController.h"
#import "TRDateFormatter.h"
#import "TRWeatherUpdate.h"
#import "TRTemperatureFormatter.h"
#import "TRBearingFormatter.h"
#import "TRTemperatureComparisonFormatter.h"
#import "NSMutableAttributedString+TRAttributeHelpers.h"
#import "TRGeocodeController.h"
#import "TRDailyForecast.h"
#import "TRDailyForecastViewModel.h"

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

    self.updateWeatherCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [self updateWeatherSignal];
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
    RACSignal *interval = [RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]];

    return [[[RACSignal combineLatest:@[interval, RACObserve(self, weatherUpdate), RACObserve(self, weatherUpdateError)] reduce:^id(id _, TRWeatherUpdate *weatherUpdate, NSError *weatherUpdateError) {
        if (!weatherUpdate && !weatherUpdateError) {
            return NSLocalizedString(@"Updating", nil);
        } else if (weatherUpdateError) {
            return NSLocalizedString(@"Update Failed", nil);
        } else if (weatherUpdate) {
            return [NSString localizedStringWithFormat:@"Updated %@", [self.dateFormatter stringFromDate:weatherUpdate.date]];
        } else {
            return nil;
        }
    }] startWith:nil] distinctUntilChanged];
}

- (RACSignal *)locationName
{
    return [[RACObserve(self, weatherUpdate) map:^id(TRWeatherUpdate *weatherUpdate) {
        if (!weatherUpdate) return nil;
        return [NSString stringWithFormat:@"%@, %@", weatherUpdate.city, weatherUpdate.state];
    }] startWith:nil];
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
    return [[RACObserve(self, weatherUpdate) map:^id(TRWeatherUpdate *weatherUpdate) {
        if (!weatherUpdate) return nil;
        NSString *bearing = [TRBearingFormatter abbreviatedCardinalDirectionStringFromBearing:weatherUpdate.windBearing];
        return [NSString stringWithFormat:@"%.1f mph %@", weatherUpdate.windSpeed, bearing];
    }] startWith:nil];
}

- (RACSignal *)highLowTemperatureDescription
{
    return [[[RACSignal combineLatest:@[RACObserve(self, weatherUpdate), self.settingsController.unitSystemChanged]] map:^id(RACTuple *tuple) {
        RACTupleUnpack(TRWeatherUpdate *weatherUpdate, __unused NSNumber *unitSystem) = tuple;

        if (!weatherUpdate) return nil;
        TRTemperatureFormatter *formatter = [TRTemperatureFormatter new];
        NSString *high = [formatter stringFromTemperature:weatherUpdate.currentHigh];
        NSString *low = [formatter stringFromTemperature:weatherUpdate.currentLow];
        return [NSString stringWithFormat:@"%@ / %@", high, low];
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
    return [[[[[[[self.locationController requestWhenInUseAuthorization] then:^RACSignal *{
        return [self.locationController updateCurrentLocation];
    }] flattenMap:^RACStream *(CLLocation *location) {
        return [self.geocodeController reverseGeocodeLocation:location];
    }] flattenMap:^RACStream *(CLPlacemark *placemark) {
        return [self.forecastController fetchWeatherUpdateForPlacemark:placemark];
    }] initially:^{
        self.weatherUpdate = nil;
        self.weatherUpdateError = nil;
    }] doNext:^(TRWeatherUpdate *weatherUpdate) {
        self.weatherUpdate = weatherUpdate;
    }] doError:^(NSError *error) {
        self.weatherUpdateError = error;
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
        color = [color lighterColorByAmount:1 - amount];
    }

    return color;
}

@end
