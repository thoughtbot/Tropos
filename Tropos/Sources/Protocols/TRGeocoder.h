@import CoreLocation;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Geocoder)
@protocol TRGeocoder <NSObject>

- (void)reverseGeocodeLocation:(CLLocation *)location
             completionHandler:(CLGeocodeCompletionHandler)completionHandler;

- (void)cancelGeocode;

@end

@interface CLGeocoder (TRGeocoder) <TRGeocoder>
@end

NS_ASSUME_NONNULL_END
