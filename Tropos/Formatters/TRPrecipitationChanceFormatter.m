#import "TRPrecipitationChanceFormatter.h"

@implementation TRPrecipitationChanceFormatter

#pragma mark - Class Methods

+ (NSString *)precipitationChanceStringFromPrecipitation:(Precipitation *)precipitation
{
    NSString *adjective = [self localizedAdjectiveForPrecipitationChance:[precipitation chance]];
    NSString *precipitationName = [self localizedNameForPrecipitationType:[precipitation type]];

    return NSLocalizedString([adjective stringByAppendingString:precipitationName], nil);
}

#pragma mark - Private Methods

+ (NSString *)localizedAdjectiveForPrecipitationChance:(PrecipitationChance)chance
{
    switch (chance) {
        case PrecipitationChanceGood:
            return @"Good";
        case PrecipitationChanceSlight:
            return @"Slight";
        case PrecipitationChanceNone:
            return @"None";
    }
}

+ (NSString *)localizedNameForPrecipitationType:(NSString *)type
{
    return [type capitalizedString];
}

@end
