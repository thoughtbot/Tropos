@import CoreLocation;
#import "CWLocationController.h"

@interface CWLocationController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, copy) CWLocationCompletionBlock completionBlock;
@property (nonatomic, copy) CWLocationErrorBlock errorBlock;

@end

@implementation CWLocationController

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    return self;
}

- (void)updateLocationWithCompletion:(CWLocationCompletionBlock)completionBlock
                          errorBlock:(CWLocationErrorBlock)errorBlock
{
    NSParameterAssert(completionBlock);
    NSParameterAssert(errorBlock);
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.completionBlock = completionBlock;
    self.errorBlock = errorBlock;
}

+ (NSString *)coordinateStringFromLatitude:(double)latitude
                                 longitude:(double)longitude
{
    NSInteger latitudeSeconds = (NSInteger)(latitude * 3600);
    NSInteger latitudeDegrees = latitudeSeconds / 3600;
    latitudeSeconds = ABS(latitudeSeconds % 3600);
    NSInteger latitudeMinutes = latitudeSeconds / 60;
    latitudeSeconds %= 60;

    NSInteger longitudeSeconds = (NSInteger)(longitude * 3600);
    NSInteger longitudeDegrees = longitudeSeconds / 3600;
    longitudeSeconds = ABS(longitudeSeconds % 3600);
    NSInteger longitudeMinutes = longitudeSeconds / 60;
    longitudeSeconds %= 60;

    NSString *latitudeDirection = latitudeDegrees >= 0 ? @"N": @"S";
    NSString *longitudeDirection = longitudeDegrees >= 0 ? @"E": @"W";

    return [NSString stringWithFormat:@"%ld° %ld' %ld\" %@ %ld° %ld' %ld\" %@",
            (long)(ABS(latitudeDegrees)),
            (long)latitudeMinutes,
            (long)latitudeSeconds,
            latitudeDirection,
            (long)ABS(longitudeDegrees),
            (long)longitudeMinutes,
            (long)longitudeSeconds,
            longitudeDirection];

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.lastObject;
    NSDate *lastLocationDate = location.timestamp;
    NSDate *fiveSecondsAgo = [NSDate dateWithTimeIntervalSinceNow:-5];
    NSComparisonResult result = [lastLocationDate compare:fiveSecondsAgo];
    if (result == NSOrderedAscending) {
        return;
    }

    [self.locationManager stopUpdatingLocation];
    CLLocationCoordinate2D coordinate = location.coordinate;
    double latitude = coordinate.latitude;
    double longitude = coordinate.longitude;
    self.completionBlock(latitude, longitude);
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    self.errorBlock(error);
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusDenied) {
        NSError *error = [NSError errorWithDomain:CWErrorDomain
                                             code:CWErrorLocationDenied
                                         userInfo:nil];
        self.errorBlock(error);
    } else if (status == kCLAuthorizationStatusDenied) {
        NSError *error = [NSError errorWithDomain:CWErrorDomain
                                             code:CWErrorLocationRestricted
                                         userInfo:nil];
        self.errorBlock(error);
    }
}

@end
