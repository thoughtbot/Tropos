#import "NSDate+CWRelativeDate.h"

@implementation NSDate (CWRelativeDate)

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
