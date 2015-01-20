@class TRWeatherViewModel;

@interface TRWeatherController : NSObject

@property (nonatomic, readonly) RACSignal *locationName;
@property (nonatomic, readonly) RACSignal *status;
@property (nonatomic, readonly) TRWeatherViewModel *weatherViewModel;

- (void)updateWeather;

@end
