#import "TRTemperatureComparisonFormatter.h"

@interface TRTemperatureComparisonFormatter (Tests)

+ (NSCalendar *)calendar;

@end

SpecBegin(TRTemperatureComparisonFormatter)

NSDate* (^dateFromString) (NSString*) = ^NSDate* (NSString *dateString) {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    return [dateFormatter dateFromString:dateString];
};

describe(@"TRTemperatureComparisonFormatter", ^{
    describe(@"localizedStringFromComparison:adjective:precipitation", ^{
        it(@"bases the time of day off of the date", ^{
            [[TRTemperatureComparisonFormatter calendar] setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            NSString *adjective;
            NSDate *date = dateFromString(@"2015-05-15 22:00:00 UTC");
            TRTemperatureComparisonFormatter *formatter = [[TRTemperatureComparisonFormatter alloc] initWithDate:date];

            NSString *stringComparison = [formatter localizedStringFromComparison:TRTemperatureComparisonSame
                                                              adjective:&adjective
                                                          precipitation:@""];

            expect(stringComparison).to.equal(@"It's the same tonight as last night.");
        });
    });
});

SpecEnd
