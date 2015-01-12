#import "CWWeatherViewModel.h"
#import "CWCurrentConditions.h"
#import "CWHistoricalConditions.h"
#import "CWTemperature.h"
#import "CWTemperatureComparisonFormatter.h"
#import "NSMutableAttributedString+CWAttributeHelpers.h"
#import "CWBearingFormatter.h"
#import "CWSettingsController.h"
#import "CWTemperatureFormatter.h"

@interface CWWeatherViewModel ()

@property (nonatomic) CWCurrentConditions *currentConditions;
@property (nonatomic) CWHistoricalConditions *yesterdaysConditions;

@end

@implementation CWWeatherViewModel

- (instancetype)initWithCurrentConditions:(CWCurrentConditions *)currentConditions yesterdaysConditions:(CWHistoricalConditions *)yesterdaysConditions
{
    self = [super init];
    if (!self) return nil;

    self.currentConditions = currentConditions;
    self.yesterdaysConditions = yesterdaysConditions;

    return self;
}

#pragma mark - Properties

- (UIImage *)conditionsImage
{
    return [UIImage imageNamed:self.currentConditions.conditionsDescription];
}

- (NSString *)formattedTemperatureRange
{
    CWTemperatureFormatter *formatter = [CWTemperatureFormatter new];
    formatter.usesMetricSystem = [[CWSettingsController new] unitSystem] == CWUnitSystemMetric;
    NSString *high = [formatter stringFromTemperature:self.currentConditions.highTemperature];
    NSString *low = [formatter stringFromTemperature:self.currentConditions.lowTemperature];
    return [NSString stringWithFormat:@"%@ / %@", high, low];
}

- (NSString *)formattedWindSpeed
{
    NSString *bearing = [CWBearingFormatter abbreviatedCardinalDirectionStringFromBearing:self.currentConditions.windBearing];
    return [NSString stringWithFormat:@"%.1f mph %@", self.currentConditions.windSpeed, bearing];
}

- (NSAttributedString *)attributedTemperatureComparison
{
    CWTemperatureComparison comparison = [self.currentConditions.temperature comparedTo:self.yesterdaysConditions.temperature];

    NSString *adjective;
    NSString *comparisonString = [CWTemperatureComparisonFormatter localizedStringFromComparison:comparison adjective:&adjective];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comparisonString];
    [attributedString setFont:[UIFont defaultUltraLightFontOfSize:37]];
    [attributedString setTextColor:[UIColor defaultTextColor]];
    [attributedString setTextColor:[self colorForTemperatureComparison:comparison] forSubstring:adjective];

    return attributedString;
}

- (NSAttributedString *)attributedDetailTemperatureComparison
{
    CWTemperatureComparison comparison = [self.currentConditions.temperature comparedTo:self.yesterdaysConditions.temperature];
    NSInteger difference = ABS([self.currentConditions.temperature
                                differenceFromTemperature:self.yesterdaysConditions.temperature]);
    CWTemperature *differenceTemperature = [CWTemperature temperatureFromFahrenheit:@(difference)];
    CWTemperatureFormatter *formatter = [CWTemperatureFormatter new];
    formatter.usesMetricSystem = [[CWSettingsController new] unitSystem] == CWUnitSystemMetric;
    NSString *differenceString = [formatter stringFromTemperature:differenceTemperature];

    NSString *adjective;
    NSString *comparisonString = [CWTemperatureComparisonFormatter localizedStringFromComparison:comparison adjective:&adjective difference:differenceString];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:comparisonString];
    [attributedString setFont:[UIFont defaultUltraLightFontOfSize:37]];
    [attributedString setTextColor:[UIColor defaultTextColor]];
    [attributedString setTextColor:[self colorForTemperatureComparison:comparison] forSubstring:adjective];

    return attributedString;
}

- (CGFloat)precipitationProbability
{
    return self.currentConditions.precipitationProbability;
}

#pragma mark - Private Methods

- (UIColor *)colorForTemperatureComparison:(CWTemperatureComparison)comparison
{
    switch (comparison) {
        case CWTemperatureComparisonSame:
            return [UIColor defaultTextColor];
        case CWTemperatureComparisonColder:
            return [UIColor coldColor];
        case CWTemperatureComparisonCooler:
            return [UIColor coolerColor];
        case CWTemperatureComparisonHotter:
            return [UIColor hotColor];
        case CWTemperatureComparisonWarmer:
            return [UIColor warmerColor];
    }
}

@end
