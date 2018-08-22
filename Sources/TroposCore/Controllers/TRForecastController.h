@import CoreLocation;
@import Foundation;
@import ReactiveObjC;

@class TRWeatherUpdate;

NS_ASSUME_NONNULL_BEGIN

@interface TRForecastController : NSObject

- (instancetype)initWithAPIKey:(NSString *)APIKey NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (RACSignal<TRWeatherUpdate *> *)fetchWeatherUpdateForPlacemark:(CLPlacemark *)placemark;

@end

NS_ASSUME_NONNULL_END
