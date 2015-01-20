@import CoreLocation;
#import "TRWeatherViewModel.h"
#import "TRLocationController.h"
#import "TRForecastController.h"
#import "TRWeatherViewModel.h"
#import "TRSettingsController.h"
#import "TRDateFormatter.h"
#import "TRWeatherUpdate.h"
#import "TRTemperatureFormatter.h"
#import "TRBearingFormatter.h"
#import "TRTemperatureComparisonFormatter.h"
#import "NSMutableAttributedString+TRAttributeHelpers.h"
#import "TRGeocodeController.h"

@interface TRWeatherViewModel ()

@property (nonatomic, readwrite) TRWeatherViewModel *weatherViewModel;

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
        [attributedString setLineHeightMultiple:1.15f spacing:2.0f];
        [attributedString setTextColor:[self colorForTemperatureComparison:comparison] forSubstring:adjective];
        
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
        RACTupleUnpack(TRWeatherUpdate *weatherUpdate, NSNumber *unitSystem) = tuple;

        if (!weatherUpdate) return nil;
        TRTemperatureFormatter *formatter = [TRTemperatureFormatter new];
        formatter.usesMetricSystem = (unitSystem.integerValue) == TRUnitSystemMetric;
        NSString *high = [formatter stringFromTemperature:weatherUpdate.currentHigh];
        NSString *low = [formatter stringFromTemperature:weatherUpdate.currentLow];
        return [NSString stringWithFormat:@"%@ / %@", high, low];
    }] startWith:nil];
}

#pragma mark - Public Methods

- (void)updateWeather
{
    [[[[[[self.locationController requestWhenInUseAuthorization] then:^RACSignal *{
        return [self.locationController updateCurrentLocation];
    }] flattenMap:^RACStream *(CLLocation *location) {
        return [self.geocodeController reverseGeocodeLocation:location];
    }] flattenMap:^RACStream *(CLPlacemark *placemark) {
        return [self.forecastController fetchWeatherUpdateForPlacemark:placemark];
    }] initially:^{
        self.weatherUpdate = nil;
        self.weatherUpdateError = nil;
    }] subscribeNext:^(TRWeatherUpdate *weatherUpdate) {
        self.weatherUpdate = weatherUpdate;
    } error:^(NSError *error) {
        self.weatherUpdateError = error;
    }];
}

#pragma mark - Private Methods

- (UIColor *)colorForTemperatureComparison:(TRTemperatureComparison)comparison
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
