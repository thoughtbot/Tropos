@class TRTemperature;

@interface TRHistoricalConditions : NSObject

@property (nonatomic, readonly) TRTemperature *temperature;

+ (instancetype)historicalConditionsFromJSON:(NSDictionary *)JSON;

@end
