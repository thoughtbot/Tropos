@import CoreLocation;
@import Foundation;
#import <ReactiveObjC/ReactiveObjC.h>

@interface TRGeocodeController : NSObject

- (RACSignal *)reverseGeocodeLocation:(CLLocation *)location;

@end
