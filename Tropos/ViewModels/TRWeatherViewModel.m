#import "TRWeatherViewModel.h"
#import "TRDailyForecastViewModel.h"
#import "TRDateFormatter.h"
#import "Tropos-Swift.h"
#import "TRPrecipitationChanceFormatter.h"
#import "TRTemperatureComparisonFormatter.h"
#import "TRTemperatureFormatter.h"
#import "TRWindSpeedFormatter.h"
#import "NSMutableAttributedString+TRAttributeHelpers.h"

@interface TRWeatherViewModel ()

@property (nonatomic) WeatherUpdate *weatherUpdate;
@property (nonatomic) TRDateFormatter *dateFormatter;

@end

@implementation TRWeatherViewModel

- (instancetype)initWithWeatherUpdate:(WeatherUpdate *)weatherUpdate
{
    self = [super init];
    if (!self) return nil;

    self.weatherUpdate = weatherUpdate;
    self.dateFormatter = [TRDateFormatter new];

    return self;
}

- (NSString *)locationName
{
    return [NSString stringWithFormat:@"%@, %@", self.weatherUpdate.city, self.weatherUpdate.state];
}

- (NSString *)updatedDateString
{
    return [self.dateFormatter stringFromDate:self.weatherUpdate.date];
}

- (UIImage *)conditionsImage
{
    return [UIImage imageNamed:self.weatherUpdate.weatherConditions.current.conditionsDescription];
}

- (NSAttributedString *)conditionsDescription
{
    TemperatureComparison comparison = [self.weatherUpdate.weatherConditions.current.currentTemperature comparedTo:self.weatherUpdate.weatherConditions.yesterday.temperature];

    NSString *adjective;
    NSString *comparisonString = [TRTemperatureComparisonFormatter localizedStringFromComparison:comparison adjective:&adjective  precipitation: self.precipitationDescription];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comparisonString];
    [attributedString setFont:[UIFont defaultUltraLightFontOfSize:26]];
    [attributedString setTextColor:[UIColor defaultTextColor]];
    
    Temperature *difference = [self.weatherUpdate.weatherConditions.current.currentTemperature temperatureDifferenceFrom:self.weatherUpdate.weatherConditions.yesterday.temperature];
    [attributedString setTextColor:[self colorForTemperatureComparison:comparison difference:difference.fahrenheitValue] forSubstring:adjective];

    return attributedString;
}

- (NSString *)windDescription
{
    return [TRWindSpeedFormatter localizedStringForWindSpeed:self.weatherUpdate.weatherConditions.current.windSpeed bearing:self.weatherUpdate.weatherConditions.current.windBearing];
}

- (NSString *)precipitationDescription
{
    Precipitation *precipitation = [[Precipitation alloc] initWithProbability:self.weatherUpdate.weatherConditions.current.precipitationProbability type:self.weatherUpdate.weatherConditions.current.precipitationType];
    return [TRPrecipitationChanceFormatter precipitationChanceStringFromPrecipitation:precipitation];
}

- (NSAttributedString *)temperatureDescription
{
    TRTemperatureFormatter *formatter = [TRTemperatureFormatter new];
    NSString *high = [formatter stringFromTemperature:self.weatherUpdate.weatherConditions.current.currentHighTemp];
    NSString *current = [formatter stringFromTemperature:self.weatherUpdate.weatherConditions.current.currentTemperature];
    NSString *low = [formatter stringFromTemperature:self.weatherUpdate.weatherConditions.current.currentLowTemp];
    NSString *temperatureString = [NSString stringWithFormat:@"%@ / %@ / %@", high, current, low];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:temperatureString];
    TemperatureComparison comparison = [self.weatherUpdate.weatherConditions.current.currentTemperature comparedTo:self.weatherUpdate.weatherConditions.yesterday.temperature];
    Temperature *difference = [self.weatherUpdate.weatherConditions.current.currentTemperature temperatureDifferenceFrom:self.weatherUpdate.weatherConditions.yesterday.temperature];
    
    NSRange rangeOfFirstSlash = [temperatureString rangeOfString:@"/"];
    NSRange rangeOfLastSlash = [temperatureString rangeOfString:@"/" options:NSBackwardsSearch];
    NSRange range = NSMakeRange(rangeOfFirstSlash.location + 1, rangeOfLastSlash.location - (rangeOfFirstSlash.location + 1));
    
    [attributedString setTextColor:[self colorForTemperatureComparison:comparison difference:difference.fahrenheitValue] forRange:range];
    
    return attributedString;
}

- (NSArray *)dailyForecasts
{
    NSArray *dailyForecasts = self.weatherUpdate.weatherConditions.current.dailyForecasts;
    NSMutableArray *forecasts = [[NSMutableArray alloc] initWithCapacity:dailyForecasts.count];

    for (DailyForecast *forecast in dailyForecasts) {
        TRDailyForecastViewModel *viewModel = [[TRDailyForecastViewModel alloc] initWithDailyForecast:forecast];
        [forecasts addObject:viewModel];
    }

    return [forecasts copy];
}

#pragma mark - Private Methods

- (UIColor *)colorForTemperatureComparison:(TemperatureComparison)comparison difference:(NSInteger)difference
{
    UIColor *color;

    switch (comparison) {
        case TemperatureComparisonSame:
            color = [UIColor defaultTextColor];
            break;
        case TemperatureComparisonColder:
            color = [UIColor coldColor];
            break;
        case TemperatureComparisonCooler:
            color = [UIColor coolerColor];
            break;
        case TemperatureComparisonHotter:
            color = [UIColor hotColor];
            break;
        case TemperatureComparisonWarmer:
            color = [UIColor warmerColor];
            break;
    }

    if (comparison == TemperatureComparisonCooler || comparison == TemperatureComparisonWarmer) {
        CGFloat amount = MIN(ABS(difference), 10) / 10.0f;
        CGFloat lighterAmount = 1 - amount;

        if (lighterAmount > 0.80) lighterAmount = 0.80f;

        color = [color lighterColorByAmount:lighterAmount];
    }

    return color;
}

@end
