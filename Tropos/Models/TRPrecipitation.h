@interface TRPrecipitation : NSObject

typedef NS_ENUM(NSUInteger, TRPrecipitationChance) {
    TRPrecipitationChanceNone,
    TRPrecipitationChanceSlight,
    TRPrecipitationChanceGood,
};

@property (nonatomic, readonly) TRPrecipitationChance chance;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic) CGFloat probability;

+ (instancetype)precipitationFromProbability:(CGFloat)probability precipitationType:(NSString *)type;

@end
