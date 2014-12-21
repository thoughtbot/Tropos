@class CWWeatherViewModel;

@interface CWWeatherController : NSObject

@property (nonatomic, readonly) CWWeatherViewModel *viewModel;

- (void)updateWeather;

@end
