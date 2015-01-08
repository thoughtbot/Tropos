@class CWWeatherViewModel, CWWeatherStatusViewModel;

@interface CWWeatherController : NSObject

@property (nonatomic, readonly) CWWeatherStatusViewModel *statusViewModel;
@property (nonatomic, readonly) CWWeatherViewModel *weatherViewModel;

- (void)updateWeather;

@end
