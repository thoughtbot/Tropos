#import "TRWeatherViewModel.h"
#import "TRDailyForecastViewModel.h"
#import "TRDateFormatter.h"
#import "Tropos-Swift.h"
#import "TRPrecipitationChanceFormatter.h"
#import "TRWindSpeedFormatter.h"
#import "NSMutableAttributedString+TRAttributeHelpers.h"

@interface TRWeatherViewModel ()

@property (nonatomic) TRWeatherUpdate *weatherUpdate;
@property (nonatomic) TRDateFormatter *dateFormatter;

@end

@implementation TRWeatherViewModel

- (instancetype)initWithWeatherUpdate:(TRWeatherUpdate *)weatherUpdate
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
    return [UIImage imageNamed:self.weatherUpdate.conditionsDescription];
}

- (NSAttributedString *)conditionsDescription
{
    TRTemperatureComparison comparison = [self.weatherUpdate.currentTemperature comparedTo:self.weatherUpdate.yesterdaysTemperature];

    NSString *adjective;
    NSString *comparisonString = [TRTemperatureComparisonFormatter localizedStringFromComparison:comparison adjective:&adjective  precipitation: self.precipitationDescription date:self.weatherUpdate.date];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comparisonString];
    [attributedString setFont:[UIFont defaultUltraLightFontOfSize:26]];
    [attributedString setTextColor:[UIColor defaultTextColor]];
    TRTemperature *difference = [self.weatherUpdate.currentTemperature temperatureDifferenceFrom:self.weatherUpdate.yesterdaysTemperature];
    [attributedString setTextColor:[self colorForTemperatureComparison:comparison difference:difference.fahrenheitValue] forSubstring:adjective];

    return attributedString;
}

- (NSString *)windDescription
{
    return [TRWindSpeedFormatter localizedStringForWindSpeed:self.weatherUpdate.windSpeed bearing:self.weatherUpdate.windBearing];
}

- (NSString *)precipitationDescription
{
    TRPrecipitation *precipitation = [[TRPrecipitation alloc] initWithProbability:(float)self.weatherUpdate.precipitationPercentage type:self.weatherUpdate.precipitationType];
    return [TRPrecipitationChanceFormatter precipitationChanceStringFromPrecipitation:precipitation];
}

- (NSAttributedString *)temperatureDescription
{
    TRTemperatureFormatter *formatter = [TRTemperatureFormatter new];
    NSString *high = [formatter stringFromTemperature:self.weatherUpdate.currentHigh];
    NSString *current = [formatter stringFromTemperature:self.weatherUpdate.currentTemperature];
    NSString *low = [formatter stringFromTemperature:self.weatherUpdate.currentLow];
    NSString *temperatureString = [NSString stringWithFormat:@"%@ / %@ / %@", high, current, low];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:temperatureString];
    TRTemperatureComparison comparison = [self.weatherUpdate.currentTemperature comparedTo:self.weatherUpdate.yesterdaysTemperature];
    TRTemperature *difference = [self.weatherUpdate.currentTemperature temperatureDifferenceFrom:self.weatherUpdate.yesterdaysTemperature];
    
    NSRange rangeOfFirstSlash = [temperatureString rangeOfString:@"/"];
    NSRange rangeOfLastSlash = [temperatureString rangeOfString:@"/" options:NSBackwardsSearch];
    NSRange range = NSMakeRange(rangeOfFirstSlash.location + 1, rangeOfLastSlash.location - (rangeOfFirstSlash.location + 1));
    
    [attributedString setTextColor:[self colorForTemperatureComparison:comparison difference:difference.fahrenheitValue] forRange:range];
    
    return attributedString;
}

- (NSArray *)dailyForecasts
{
    NSMutableArray *forecasts = [[NSMutableArray alloc] initWithCapacity:self.weatherUpdate.dailyForecasts.count];

    for (TRDailyForecast *forecast in self.weatherUpdate.dailyForecasts) {
        TRDailyForecastViewModel *viewModel = [[TRDailyForecastViewModel alloc] initWithDailyForecast:forecast];
        [forecasts addObject:viewModel];
    }

    return [forecasts copy];
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
