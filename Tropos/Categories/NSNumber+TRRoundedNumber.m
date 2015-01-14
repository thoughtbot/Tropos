#import "NSNumber+TRRoundedNumber.h"

@implementation NSNumber (TRRoundedNumber)

- (NSNumber *)roundedNumber
{
    return @(roundf([self floatValue]));
}

@end
