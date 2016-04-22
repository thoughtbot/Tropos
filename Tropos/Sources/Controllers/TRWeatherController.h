@interface TRWeatherController : NSObject

@property (nonatomic, readonly) RACSignal *locationName;
@property (nonatomic, readonly) RACSignal *status;
@property (nonatomic, readonly) RACSignal *conditionsImage;
@property (nonatomic, readonly) RACSignal *conditionsDescription;
@property (nonatomic, readonly) RACSignal *windDescription;
@property (nonatomic, readonly) RACSignal *highLowTemperatureDescription;
@property (nonatomic, readonly) RACSignal *dailyForecastViewModels;
@property (nonatomic, readonly) RACSignal *precipitationDescription;
@property (nonatomic, readonly) RACCommand *updateWeatherCommand;

@end
