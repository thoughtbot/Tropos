@class TRTemperature;

@interface TRCurrentConditions : NSObject

@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, readonly) TRTemperature *temperature;
@property (nonatomic, readonly) TRTemperature *highTemperature;
@property (nonatomic, readonly) TRTemperature *lowTemperature;
@property (nonatomic, readonly) CGFloat windSpeed;
@property (nonatomic, readonly) CGFloat windBearing;
@property (nonatomic, readonly) CGFloat precipitationProbability;
@property (nonatomic, readonly) NSDate *date;

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON;

@end
