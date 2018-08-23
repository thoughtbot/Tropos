@import CoreLocation;
@import Foundation;
@import ReactiveObjC;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(ForecastController)
@interface TRForecastController : NSObject

- (instancetype)initWithAPIKey:(NSString *)APIKey NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (RACSignal *)fetchWeatherUpdateForPlacemark:(CLPlacemark *)placemark NS_REFINED_FOR_SWIFT;

@end

NS_ASSUME_NONNULL_END
