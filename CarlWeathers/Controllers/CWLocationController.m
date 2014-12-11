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
    self.completionBlock = completionBlock;
    self.errorBlock = errorBlock;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    CLLocation *location = locations.lastObject;
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
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        NSError *error = [NSError errorWithDomain:CWErrorDomain
                                             code:CWErrorLocationUnaccessible
                                         userInfo:nil];
        self.errorBlock(error);
    }
}

@end
