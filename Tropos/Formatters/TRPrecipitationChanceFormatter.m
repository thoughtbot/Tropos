#import "Tropos-Swift.h"
#import "TRPrecipitationChanceFormatter.h"

@implementation TRPrecipitationChanceFormatter

#pragma mark - Class Methods

+ (NSString *)precipitationChanceStringFromPrecipitation:(TRPrecipitation *)precipitation
{
    NSString *adjective = [self localizedAdjectiveForPrecipitationChance:[precipitation chance]];
    NSString *precipitationName = [self localizedNameForPrecipitationType:[precipitation type]];

    return NSLocalizedString([adjective stringByAppendingString:precipitationName], nil);
}

#pragma mark - Private Methods

+ (NSString *)localizedAdjectiveForPrecipitationChance:(TRPrecipitationChance)chance
{
    switch (chance) {
        case TRPrecipitationChanceGood: return @"Good";
        case TRPrecipitationChanceSlight: return @"Slight";
        case TRPrecipitationChanceNone: return @"None";
    }
}

+ (NSString *)localizedNameForPrecipitationType:(NSString *)type
{
    return [type capitalizedString];
}

@end
