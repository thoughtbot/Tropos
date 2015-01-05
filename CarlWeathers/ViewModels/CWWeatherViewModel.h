@class CWWeatherLocation;
@class CWCurrentConditions;
@class CWHistoricalConditions;

@interface CWWeatherViewModel : NSObject

@property (nonatomic, copy, readonly) NSString *locationName;
@property (nonatomic, copy, readonly) NSString *formattedDate;
@property (nonatomic, readonly) UIImage *conditionsImage;
@property (nonatomic, copy, readonly) NSString *formattedTemperatureRange;
@property (nonatomic, copy, readonly) NSString *formattedWindSpeed;
@property (nonatomic, copy, readonly) NSAttributedString *attributedTemperatureComparison;
@property (nonatomic, readonly) CGFloat precipitationProbability;

- (instancetype)initWithWeatherLocation:(CWWeatherLocation *)weatherLocation currentConditions:(CWCurrentConditions *)currentConditions yesterdaysConditions:(CWHistoricalConditions *)conditions;

@end
