@import CoreLocation;
@import Foundation;
#import <ReactiveObjC/ReactiveObjC.h>

#import "TRGeocoder.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(GeocodeController)
@interface TRGeocodeController : NSObject

- (instancetype)initWithGeocoder:(id<TRGeocoder>)geocoder;

- (RACSignal *)reverseGeocodeLocation:(CLLocation *)location;

@end

NS_ASSUME_NONNULL_END
