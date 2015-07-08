#import "UnitTests-Swift.h"
#import "TRTemperatureComparisonFormatter.h"

@interface TRTemperatureComparisonFormatter (Tests)

+ (NSCalendar *)calendar;

@end

SpecBegin(TRTemperatureComparisonFormatter)

NSDate* (^dateFromString) (NSString*) = ^NSDate *(NSString *dateString) {
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
            NSString *stringComparison = [TRTemperatureComparisonFormatter localizedStringFromComparison:TemperatureComparisonSame
                                                                                               adjective:&adjective
                                                                                           precipitation:@""
                                                                                                    date:date];

            expect(stringComparison).to.equal(@"It's the same tonight as last night.");
        });
    });
});

SpecEnd
