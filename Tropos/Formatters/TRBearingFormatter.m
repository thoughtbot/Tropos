#import "TRBearingFormatter.h"

typedef NS_ENUM(NSUInteger, TRCardinalDirection) {
    TRCardinalDirectionNorth,
    TRCardinalDirectionNorthEast,
    TRCardinalDirectionEast,
    TRCardinalDirectionSouthEast,
    TRCardinalDirectionSouth,
    TRCardinalDirectionSouthWest,
    TRCardinalDirectionWest,
    TRCardinalDirectionNorthWest
};

@implementation TRBearingFormatter

#pragma mark - Public Methods

+ (NSString *)cardinalDirectionStringFromBearing:(double)bearing
{
    TRCardinalDirection direction = [self cardinalDirectionFromBearing:bearing];

    switch (direction) {
        case TRCardinalDirectionNorth:
            return NSLocalizedString(@"North", nil);
        case TRCardinalDirectionNorthEast:
            return NSLocalizedString(@"Northeast", nil);
        case TRCardinalDirectionEast:
            return NSLocalizedString(@"East", nil);
        case TRCardinalDirectionSouthEast:
            return NSLocalizedString(@"Southeast", nil);
        case TRCardinalDirectionSouth:
            return NSLocalizedString(@"South", nil);
        case TRCardinalDirectionSouthWest:
            return NSLocalizedString(@"Southwest", nil);
        case TRCardinalDirectionWest:
            return NSLocalizedString(@"West", nil);
        case TRCardinalDirectionNorthWest:
            return NSLocalizedString(@"Northwest", nil);
    }
}

+ (NSString *)abbreviatedCardinalDirectionStringFromBearing:(double)bearing
{
    TRCardinalDirection direction = [self cardinalDirectionFromBearing:bearing];

    switch (direction) {
        case TRCardinalDirectionNorth:
            return NSLocalizedString(@"N", nil);
        case TRCardinalDirectionNorthEast:
            return NSLocalizedString(@"NE", nil);
        case TRCardinalDirectionEast:
            return NSLocalizedString(@"E", nil);
        case TRCardinalDirectionSouthEast:
            return NSLocalizedString(@"SE", nil);
        case TRCardinalDirectionSouth:
            return NSLocalizedString(@"S", nil);
        case TRCardinalDirectionSouthWest:
            return NSLocalizedString(@"SW", nil);
        case TRCardinalDirectionWest:
            return NSLocalizedString(@"W", nil);
        case TRCardinalDirectionNorthWest:
            return NSLocalizedString(@"NW", nil);
    }
}

#pragma mark - Private Methods

+ (TRCardinalDirection)cardinalDirectionFromBearing:(double)bearing
{
    if (bearing < 22.5) {
        return TRCardinalDirectionNorth;
    } else if (bearing < 67.5) {
        return TRCardinalDirectionNorthEast;
    } else if (bearing < 112.5) {
        return TRCardinalDirectionEast;
    } else if (bearing < 157.5) {
        return TRCardinalDirectionSouthEast;
    } else if (bearing < 202.5) {
        return TRCardinalDirectionSouth;
    } else if (bearing < 247.5) {
        return TRCardinalDirectionSouthWest;
    } else if (bearing < 292.5) {
        return TRCardinalDirectionWest;
    } else if (bearing < 337.5) {
        return TRCardinalDirectionNorthWest;
    } else {
        return TRCardinalDirectionNorth;
    }
}

@end
