@class TRTemperature;
@class Temperature;

@interface TRDailyForecast : NSObject

@property (nonatomic, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSString *conditionsDescription;
@property (nonatomic, readonly) Temperature *highTemperature;
@property (nonatomic, readonly) Temperature *lowTemperature;

- (instancetype)initWithJSON:(NSDictionary *)JSON;

@end
