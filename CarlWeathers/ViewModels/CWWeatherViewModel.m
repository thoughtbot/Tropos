#import <FormatterKit/TTTLocationFormatter.h>
#import "CWWeatherViewModel.h"
#import "CWWeatherLocation.h"
#import "CWCurrentConditions.h"
#import "CWHistoricalConditions.h"
#import "CWTemperature.h"
#import "CWTemperatureComparisonFormatter.h"
#import "NSMutableAttributedString+CWAttributeHelpers.h"

@interface CWWeatherViewModel ()

@property (nonatomic) CWWeatherLocation *weatherLocation;
@property (nonatomic) CWCurrentConditions *currentConditions;
@property (nonatomic) CWHistoricalConditions *yesterdaysConditions;
@property (nonatomic) TTTLocationFormatter *locationFormatter;

@end

@implementation CWWeatherViewModel

- (instancetype)initWithWeatherLocation:(CWWeatherLocation *)weatherLocation currentConditions:(CWCurrentConditions *)currentConditions yesterdaysConditions:(CWHistoricalConditions *)yesterdaysConditions
{
    self = [super init];
    if (!self) return nil;

    self.weatherLocation = weatherLocation;
    self.currentConditions = currentConditions;
    self.yesterdaysConditions = yesterdaysConditions;

    self.locationFormatter = [TTTLocationFormatter new];
    self.locationFormatter.coordinateStyle = TTTDegreesMinutesSecondsFormat;
    self.locationFormatter.bearingStyle = TTTBearingAbbreviationWordStyle;

    return self;
}

#pragma mark - Properties

- (NSString *)locationName
{
    return [NSString stringWithFormat:@"%@, %@", self.weatherLocation.city, self.weatherLocation.state];
}

- (NSString *)formattedCoordinate
{
    return [self.locationFormatter stringFromCoordinate:self.weatherLocation.coordinate];
}

- (UIImage *)conditionsImage
{
    return [UIImage imageNamed:self.currentConditions.conditionsDescription];
}

- (NSString *)formattedTemperatureRange
{
    return [NSString stringWithFormat:@"%@° / %@°", self.currentConditions.highTemperature, self.currentConditions.lowTemperature];
}

- (NSString *)formattedWindSpeed
{
    NSString *bearing = [self.locationFormatter stringFromBearing:self.currentConditions.windBearing];
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

#pragma mark - Private Methods

- (UIColor *)colorForTemperatureComparison:(CWTemperatureComparison)comparison
{
    switch (comparison) {
        case CWTemperatureComparisonSame:
            return [UIColor defaultTextColor];
        case CWTemperatureComparisonColder:
        case CWTemperatureComparisonCooler:
            return [UIColor coldColor];
        case CWTemperatureComparisonHotter:
        case CWTemperatureComparisonWarmer:
            return [UIColor hotColor];
    }
}

@end
