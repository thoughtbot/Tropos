@class CWTemperature;

@interface CWCurrentConditions : NSObject

@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, readonly) CWTemperature *temperature;
@property (nonatomic, readonly) CGFloat highTemperature;
@property (nonatomic, readonly) CGFloat lowTemperature;
@property (nonatomic, readonly) CGFloat precipitationProbability;

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON;

@end
