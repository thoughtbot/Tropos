@class DailyForecast;

@interface TRDailyForecastViewModel : NSObject

@property (nonatomic, readonly) NSString *dayOfWeek;
@property (nonatomic, readonly) UIImage *conditionsImage;
@property (nonatomic, readonly) NSString *highTemperature;
@property (nonatomic, readonly) NSString *lowTemperature;

- (instancetype)initWithDailyForecast:(DailyForecast *)dailyForecast;

@end
