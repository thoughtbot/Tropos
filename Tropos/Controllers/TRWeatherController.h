@class TRWeatherViewModel, TRWeatherStatusViewModel;

@interface TRWeatherController : NSObject

@property (nonatomic, readonly) TRWeatherStatusViewModel *statusViewModel;
@property (nonatomic, readonly) TRWeatherViewModel *weatherViewModel;

- (void)updateWeather;

@end
