@import CoreLocation;

@interface CWWeatherLocation : NSObject

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *state;

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark;

@end
