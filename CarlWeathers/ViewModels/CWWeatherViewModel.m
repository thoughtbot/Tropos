#import "CWWeatherViewModel.h"
#import "CWWeatherLocation.h"
#import "CWCurrentConditions.h"
#import "CWHistoricalConditions.h"
#import "CWTemperature.h"
#import "CWTemperatureComparisonFormatter.h"
#import "NSMutableAttributedString+CWAttributeHelpers.h"
#import "CWBearingFormatter.h"
#import "CWSettingsController.h"
#import "CWTemperatureFormatter.h"

@interface CWWeatherViewModel ()

@property (nonatomic) CWWeatherLocation *weatherLocation;
@property (nonatomic) CWCurrentConditions *currentConditions;
@property (nonatomic) CWHistoricalConditions *yesterdaysConditions;

@end

@implementation CWWeatherViewModel

- (instancetype)initWithWeatherLocation:(CWWeatherLocation *)weatherLocation currentConditions:(CWCurrentConditions *)currentConditions yesterdaysConditions:(CWHistoricalConditions *)yesterdaysConditions
{
    self = [super init];
    if (!self) return nil;

    self.weatherLocation = weatherLocation;
    self.currentConditions = currentConditions;
    self.yesterdaysConditions = yesterdaysConditions;

    return self;
}

#pragma mark - Properties

- (NSString *)locationName
{
    return [NSString stringWithFormat:@"%@, %@", self.weatherLocation.city, self.weatherLocation.state];
}

- (NSString *)formattedDate
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    NSString *formattedDate = [dateFormatter stringFromDate:self.currentConditions.date];
    return [NSString stringWithFormat:@"Last updated: %@", formattedDate];
}

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
