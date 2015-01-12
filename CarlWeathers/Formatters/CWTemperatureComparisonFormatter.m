#import "CWTemperatureComparisonFormatter.h"

typedef NS_ENUM(NSUInteger, CWTimeOfDay) {
    CWTimeOfDayMorning,
    CWTimeOfDayDay,
    CWTimeOfDayAfternoon,
    CWTimeOfDayNight
};

@implementation CWTemperatureComparisonFormatter

+ (NSString *)localizedStringFromComparison:(CWTemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective
{
    NSString *formatString = (comparison == CWTemperatureComparisonSame)? NSLocalizedString(@"SameTemperatureFormat", nil) : NSLocalizedString(@"DifferentTemperatureFormat", nil);
    *adjective = [self localizedAdjectiveForTemperatureComparison:comparison];

    return [NSString stringWithFormat:formatString, *adjective, [self localizedCurrentTimeOfDay], [self localizedPreviousTimeOfDay]];
}

+ (NSString *)localizedStringFromComparison:(CWTemperatureComparison)comparison
                                  adjective:(NSString *__autoreleasing *)adjective
                                 difference:(NSString *)difference
{
    NSString *formatString = (comparison == CWTemperatureComparisonSame)? NSLocalizedString(@"SameTemperatureFormat", nil) : NSLocalizedString(@"DifferentTemperatureFormat", nil);
    *adjective = [NSString stringWithFormat:@"%@ %@", difference, [self localizedAdjectiveForTemperatureComparison:comparison]];

    return [NSString stringWithFormat:formatString, *adjective, [self localizedCurrentTimeOfDay], [self localizedPreviousTimeOfDay]];
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

+ (NSString *)localizedCurrentTimeOfDay
{
    switch ([self timeOfDay]) {
        case CWTimeOfDayNight:
            return NSLocalizedString(@"Tonight", nil);
        case CWTimeOfDayMorning:
            return NSLocalizedString(@"ThisMorning", nil);
        case CWTimeOfDayDay:
            return NSLocalizedString(@"Today", nil);
        case CWTimeOfDayAfternoon:
            return NSLocalizedString(@"ThisAfternoon", nil);
        default:
            break;
    }
}

+ (NSString *)localizedPreviousTimeOfDay
{
    switch ([self timeOfDay]) {
        case CWTimeOfDayNight:
            return NSLocalizedString(@"LastNight", nil);
        case CWTimeOfDayMorning:
            return NSLocalizedString(@"YesterdayMorning", nil);
        case CWTimeOfDayDay:
            return NSLocalizedString(@"Yesterday", nil);
        case CWTimeOfDayAfternoon:
            return NSLocalizedString(@"YesterdayAfternoon", nil);
        default:
            break;
    }
}

+ (CWTimeOfDay)timeOfDay;
{
    NSDateComponents *dateComponents = [[self calendar] components:NSCalendarUnitHour fromDate:[NSDate date]];

    if (dateComponents.hour < 4) {
        return CWTimeOfDayNight;
    } else if (dateComponents.hour < 9) {
        return CWTimeOfDayMorning;
    } else if (dateComponents.hour < 14) {
        return CWTimeOfDayDay;
    } else if (dateComponents.hour < 17) {
        return CWTimeOfDayAfternoon;
    } else {
        return CWTimeOfDayNight;
    }
}

+ (NSCalendar *)calendar
{
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

@end
