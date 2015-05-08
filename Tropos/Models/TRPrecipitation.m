#import "TRPrecipitation.h"

@interface TRPrecipitation ()

@property (nonatomic, readwrite) TRPrecipitationChance chance;
@property (nonatomic, readwrite) NSString *type;

@end

@implementation TRPrecipitation

#pragma mark - Class Methods

+ (instancetype)precipitationFromProbability:(CGFloat)probability precipitationType:(NSString *)type
{
    return [[self alloc] initWithProbability:probability precipitationType:type];
}

#pragma mark - Initialization

- (instancetype)initWithProbability:(CGFloat)probability precipitationType:(NSString *)type
{
    self = [super init];
    if (!self) return nil;

    self.probability = probability;
    self.type = type;

    return self;
}

#pragma mark - Public Methods

- (TRPrecipitationChance)chance
{
    if (self.probability > 30.0f) {
        return TRPrecipitationChanceGood;
    }
    else if (self.probability > 0.0f) {
        return TRPrecipitationChanceSlight;
    } else {
        return TRPrecipitationChanceNone;
    }
}

@end
