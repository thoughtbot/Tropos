#import "TRDateFormatter.h"

@interface TRDateFormatter ()

@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation TRDateFormatter

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.calendar = [NSCalendar currentCalendar];
    self.dateFormatter = [NSDateFormatter new];

    return self;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date toDate:[NSDate date] options:kNilOptions];

    if (components.day > 0) {
        self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
        return [self.dateFormatter stringFromDate:date];
    } else if (components.hour > 0) {
        self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
        self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
        return [self.dateFormatter stringFromDate:date];
    } else if (components.minute > 0) {
        NSString *unit = (components.minute == 1)? @"minute" : @"minutes";
        return [NSString stringWithFormat:@"%zd %@ ago", components.minute, unit];
    } else if (components.second > 5) {
        NSString *unit = (components.second == 1)? @"second" : @"seconds";
        return [NSString stringWithFormat:@"%zd %@ ago", components.second, unit];
    } else {
        return NSLocalizedString(@"just now", nil);
    }
}

@end
