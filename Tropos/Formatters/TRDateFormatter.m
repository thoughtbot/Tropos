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
    self.dateFormatter.doesRelativeDateFormatting = YES;

    return self;
}

- (NSString *)stringFromDate:(NSDate *)date
{
    NSString *dateString = [self dateStringFromDate:date];
    NSString *timeString = [self timeStringFromDate:date];

    NSString *formattedString;

    if (!dateString) {
        formattedString = [NSString localizedStringWithFormat:NSLocalizedString(@"UpdatedAtTime", nil), timeString];
    } else {
        formattedString = [NSString localizedStringWithFormat:NSLocalizedString(@"UpdatedAtDateAndTime", nil), dateString, timeString];
    }

    return formattedString;
}

- (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date toDate:[NSDate date] options:kNilOptions];

    if (components.day == 0) {
        return nil;
    }

    self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
    self.dateFormatter.timeStyle = NSDateFormatterNoStyle;

    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)timeStringFromDate:(NSDate *)date
{
    self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
    self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
    return [self.dateFormatter stringFromDate:date];
}

@end
