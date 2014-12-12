#import "NSNumber+CWRoundedNumber.h"

@implementation NSNumber (CWRoundedNumber)

- (NSNumber *)roundedNumber
{
    return @(roundf([self floatValue]));
}

@end
