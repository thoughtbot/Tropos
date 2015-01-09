#import "CWDateFormatter.h"

@interface CWDateFormatter ()

@property (nonatomic) NSCalendar *calendar;
@property (nonatomic) NSDateFormatter *dateFormatter;

@end

@implementation CWDateFormatter

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
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];

    if (timeInterval < 60) {
        return [NSString stringWithFormat:@"%f seconds ago", timeInterval];
    } else if (timeInterval < 3600) {
        return [NSString stringWithFormat:@"%f minutes ago", timeInterval];
    } else if (timeInterval < 86400) {
        self.dateFormatter.dateStyle = NSDateFormatterNoStyle;
        self.dateFormatter.timeStyle = NSDateFormatterShortStyle;
        return [self.dateFormatter stringFromDate:date];
    } else {
        self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
        return [self.dateFormatter stringFromDate:date];
    }
}

@end
