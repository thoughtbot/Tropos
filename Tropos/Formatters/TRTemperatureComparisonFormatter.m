#import "TRTemperatureComparisonFormatter.h"

typedef NS_ENUM(NSUInteger, TRTimeOfDay) {
    TRTimeOfDayMorning,
    TRTimeOfDayDay,
    TRTimeOfDayAfternoon,
    TRTimeOfDayNight
};

@implementation TRTemperatureComparisonFormatter

+ (NSString *)localizedStringFromComparison:(TemperatureComparison)comparison adjective:(NSString *__autoreleasing *)adjective precipitation:(NSString *)precipitation
{
    NSString *formatString = (comparison == TemperatureComparisonSame)? NSLocalizedString(@"SameTemperatureFormat", nil) : NSLocalizedString(@"DifferentTemperatureFormat", nil);
    *adjective = [self localizedAdjectiveForTemperatureComparison:comparison];

    return [NSString stringWithFormat:formatString, *adjective, [self localizedCurrentTimeOfDay], [self localizedPreviousTimeOfDay], precipitation];
}

#pragma mark - Private Methods

+ (NSString *)localizedAdjectiveForTemperatureComparison:(TemperatureComparison)comparison
{
    switch (comparison) {
        case TemperatureComparisonHotter:
            return NSLocalizedString(@"Hotter", nil);
        case TemperatureComparisonWarmer:
            return NSLocalizedString(@"Warmer", nil);
        case TemperatureComparisonCooler:
            return NSLocalizedString(@"Cooler", nil);
        case TemperatureComparisonColder:
            return NSLocalizedString(@"Colder", nil);
        case TemperatureComparisonSame:
            return NSLocalizedString(@"Same", nil);
    }
}

+ (NSString *)localizedCurrentTimeOfDay
{
    switch ([self timeOfDay]) {
        case TRTimeOfDayNight:
            return NSLocalizedString(@"Tonight", nil);
        case TRTimeOfDayMorning:
            return NSLocalizedString(@"ThisMorning", nil);
        case TRTimeOfDayDay:
            return NSLocalizedString(@"Today", nil);
        case TRTimeOfDayAfternoon:
            return NSLocalizedString(@"ThisAfternoon", nil);
        default:
            break;
    }
}

+ (NSString *)localizedPreviousTimeOfDay
{
    switch ([self timeOfDay]) {
        case TRTimeOfDayNight:
            return NSLocalizedString(@"LastNight", nil);
        case TRTimeOfDayMorning:
            return NSLocalizedString(@"YesterdayMorning", nil);
        case TRTimeOfDayDay:
            return NSLocalizedString(@"Yesterday", nil);
        case TRTimeOfDayAfternoon:
            return NSLocalizedString(@"YesterdayAfternoon", nil);
        default:
            break;
    }
}

+ (TRTimeOfDay)timeOfDay;
{
    NSDateComponents *dateComponents = [[self calendar] components:NSCalendarUnitHour fromDate:[NSDate date]];

    if (dateComponents.hour < 4) {
        return TRTimeOfDayNight;
    } else if (dateComponents.hour < 9) {
        return TRTimeOfDayMorning;
    } else if (dateComponents.hour < 14) {
        return TRTimeOfDayDay;
    } else if (dateComponents.hour < 17) {
        return TRTimeOfDayAfternoon;
    } else {
        return TRTimeOfDayNight;
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
