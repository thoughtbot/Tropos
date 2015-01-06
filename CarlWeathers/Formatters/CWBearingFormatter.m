#import "CWBearingFormatter.h"

typedef NS_ENUM(NSUInteger, CWCardinalDirection) {
    CWCardinalDirectionNorth,
    CWCardinalDirectionNorthEast,
    CWCardinalDirectionEast,
    CWCardinalDirectionSouthEast,
    CWCardinalDirectionSouth,
    CWCardinalDirectionSouthWest,
    CWCardinalDirectionWest,
    CWCardinalDirectionNorthWest
};

@implementation CWBearingFormatter

#pragma mark - Public Methods

+ (NSString *)cardinalDirectionStringFromBearing:(CGFloat)bearing
{
    CWCardinalDirection direction = [self cardinalDirectionFromBearing:bearing];

    switch (direction) {
        case CWCardinalDirectionNorth:
            return NSLocalizedString(@"North", nil);
        case CWCardinalDirectionNorthEast:
            return NSLocalizedString(@"Northeast", nil);
        case CWCardinalDirectionEast:
            return NSLocalizedString(@"East", nil);
        case CWCardinalDirectionSouthEast:
            return NSLocalizedString(@"Southeast", nil);
        case CWCardinalDirectionSouth:
            return NSLocalizedString(@"South", nil);
        case CWCardinalDirectionSouthWest:
            return NSLocalizedString(@"Southwest", nil);
        case CWCardinalDirectionWest:
            return NSLocalizedString(@"West", nil);
        case CWCardinalDirectionNorthWest:
            return NSLocalizedString(@"Northwest", nil);
    }
}

+ (NSString *)abbreviatedCardinalDirectionStringFromBearing:(CGFloat)bearing
{
    CWCardinalDirection direction = [self cardinalDirectionFromBearing:bearing];

    switch (direction) {
        case CWCardinalDirectionNorth:
            return NSLocalizedString(@"N", nil);
        case CWCardinalDirectionNorthEast:
            return NSLocalizedString(@"NE", nil);
        case CWCardinalDirectionEast:
            return NSLocalizedString(@"E", nil);
        case CWCardinalDirectionSouthEast:
            return NSLocalizedString(@"SE", nil);
        case CWCardinalDirectionSouth:
            return NSLocalizedString(@"S", nil);
        case CWCardinalDirectionSouthWest:
            return NSLocalizedString(@"SW", nil);
        case CWCardinalDirectionWest:
            return NSLocalizedString(@"W", nil);
        case CWCardinalDirectionNorthWest:
            return NSLocalizedString(@"NW", nil);
    }
}

#pragma mark - Private Methods

+ (CWCardinalDirection)cardinalDirectionFromBearing:(CGFloat)bearing
{
    if (bearing < 22.5) {
        return CWCardinalDirectionNorth;
    } else if (bearing < 67.5) {
        return CWCardinalDirectionNorthEast;
    } else if (bearing < 112.5) {
        return CWCardinalDirectionEast;
    } else if (bearing < 157.5) {
        return CWCardinalDirectionSouthEast;
    } else if (bearing < 202.5) {
        return CWCardinalDirectionSouth;
    } else if (bearing < 247.5) {
        return CWCardinalDirectionSouthWest;
    } else if (bearing < 292.5) {
        return CWCardinalDirectionWest;
    } else if (bearing < 337.5) {
        return CWCardinalDirectionNorthWest;
    } else {
        return CWCardinalDirectionNorth;
    }
}

@end
