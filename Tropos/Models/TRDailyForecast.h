@class TRTemperature;

@interface TRDailyForecast : NSObject

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, readonly) TRTemperature *highTemperature;
@property (nonatomic, readonly) TRTemperature *lowTemperature;

- (instancetype)initWithJSON:(NSDictionary *)JSON;

@end
