@class CWTemperature;

@interface CWCurrentConditions : NSObject

@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, readonly) CWTemperature *temperature;
@property (nonatomic, readonly) CWTemperature *highTemperature;
@property (nonatomic, readonly) CWTemperature *lowTemperature;
@property (nonatomic, readonly) CGFloat windSpeed;
@property (nonatomic, readonly) CGFloat windBearing;
@property (nonatomic, readonly) CGFloat precipitationProbability;

+ (instancetype)currentConditionsFromJSON:(NSDictionary *)JSON;

- (NSString *)windConditions;

@end
