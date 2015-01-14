#import "NSDate+TRRelativeDate.h"

@implementation NSDate (TRRelativeDate)

+ (NSDate *)yesterday
{
    static NSCalendar *calendar = nil;
    if (!calendar) {
        calendar = [NSCalendar currentCalendar];
    }

    NSCalendarUnit units = NSCalendarUnitMinute | NSCalendarUnitHour | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    components.day--;
    return [calendar dateFromComponents:components];
}

@end
