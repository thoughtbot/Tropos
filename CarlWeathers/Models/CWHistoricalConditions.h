@class CWTemperature;

@interface CWHistoricalConditions : NSObject

@property (nonatomic, readonly) CWTemperature *temperature;

+ (instancetype)historicalConditionsFromJSON:(NSDictionary *)JSON;

@end
