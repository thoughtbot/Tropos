@interface TRForecastController : NSObject

- (RACSignal *)fetchWeatherUpdateForPlacemark:(CLPlacemark *)placemark;

@end
