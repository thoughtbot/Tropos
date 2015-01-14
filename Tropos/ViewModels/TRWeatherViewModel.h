@class TRCurrentConditions;
@class TRHistoricalConditions;

@interface TRWeatherViewModel : NSObject

@property (nonatomic, readonly) UIImage *conditionsImage;
@property (nonatomic, copy, readonly) NSString *formattedTemperatureRange;
@property (nonatomic, copy, readonly) NSString *formattedWindSpeed;
@property (nonatomic, copy, readonly) NSAttributedString *attributedTemperatureComparison;
@property (nonatomic, readonly) CGFloat precipitationProbability;

- (instancetype)initWithCurrentConditions:(TRCurrentConditions *)currentConditions yesterdaysConditions:(TRHistoricalConditions *)conditions;

@end
