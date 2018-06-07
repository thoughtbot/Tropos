@import CoreLocation;
@import Foundation;
#import <ReactiveObjC/ReactiveObjC.h>

@interface TRForecastController : NSObject

- (RACSignal *)fetchWeatherUpdateForPlacemark:(CLPlacemark *)placemark;

@end
