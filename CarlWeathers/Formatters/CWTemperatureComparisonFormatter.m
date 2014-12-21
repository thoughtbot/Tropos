#import "CWTemperatureComparisonFormatter.h"

@implementation CWTemperatureComparisonFormatter

+ (NSString *)localizedStringFromComparison:(CWTemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective
{
    NSString *formatString = (comparison == CWTemperatureComparisonSame)? NSLocalizedString(@"SameTemperatureFormat", nil) : NSLocalizedString(@"DifferentTemperatureFormat", nil);
    *adjective = [self localizedAdjectiveForTemperatureComparison:comparison];

    return [NSString stringWithFormat:formatString, *adjective];
}

#pragma mark - Private Methods

+ (NSString *)localizedAdjectiveForTemperatureComparison:(CWTemperatureComparison)comparison
{
    switch (comparison) {
        case CWTemperatureComparisonHotter:
            return NSLocalizedString(@"Hotter", nil);
        case CWTemperatureComparisonWarmer:
            return NSLocalizedString(@"Warmer", nil);
        case CWTemperatureComparisonCooler:
            return NSLocalizedString(@"Cooler", nil);
        case CWTemperatureComparisonColder:
            return NSLocalizedString(@"Colder", nil);
        case CWTemperatureComparisonSame:
            return NSLocalizedString(@"Same", nil);
    }
}

@end
