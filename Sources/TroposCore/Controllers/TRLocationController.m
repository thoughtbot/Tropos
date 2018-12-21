#import <TroposCore/TroposCore-Swift.h>
#import "TRLocationController.h"

@interface TRLocationController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation TRLocationController

#pragma mark - Initializers

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    if (@available(iOS 10.0, *)) {
        dispatch_assert_queue(dispatch_get_main_queue());
    }

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    return self;
}

#pragma mark - Properties

- (RACSignal<NSNumber *> *)requestAlwaysAuthorization
{
    if ([self needsAuthorization]) {
        [self.locationManager requestAlwaysAuthorization];
        return [self didAuthorize];
    } else {
        return [self authorized];
    }
}

- (RACSignal<CLLocation *> *)updateCurrentLocation
{
    RACSignal *currentLocationUpdated = [[[self didUpdateLocations] map:^id(NSArray *locations) {
        return locations.lastObject;
    }] filter:^BOOL(CLLocation *location) {
        return !location.tr_isStale;
    }];

    RACSignal *locationUpdateFailed = [[[self didFailWithError] map:^id(NSError *error) {
        return [RACSignal error:error];
    }] switchToLatest];

    return [[[[RACSignal merge:@[currentLocationUpdated, locationUpdateFailed]] take:1] initially:^{
        [self.locationManager startUpdatingLocation];
    }] finally:^{
        [self.locationManager stopUpdatingLocation];
    }];
}

- (BOOL)authorizationStatusEqualTo:(CLAuthorizationStatus)status
{
    return [CLLocationManager authorizationStatus] == status;
}

#pragma mark - Private

- (BOOL)needsAuthorization
{
    return [self authorizationStatusEqualTo:kCLAuthorizationStatusNotDetermined];
}

- (RACSignal<NSNumber *> *)didAuthorize
{
    return [[[[self didChangeAuthorizationStatus] ignore:@(kCLAuthorizationStatusNotDetermined)] map:^id(NSNumber *status) {
        return @(status.integerValue == kCLAuthorizationStatusAuthorizedWhenInUse || status.integerValue == kCLAuthorizationStatusAuthorizedAlways);
    }] take:1];
}

- (RACSignal<NSNumber *> *)authorized
{
    BOOL authorized = [self authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedWhenInUse] || [self authorizationStatusEqualTo:kCLAuthorizationStatusAuthorizedAlways];
    return [RACSignal return:@(authorized)];
}

#pragma mark - CLLocationManagerDelegate Signals

- (RACSignal<NSArray<CLLocation *> *> *)didUpdateLocations
{
    return [[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] reduceEach:^id(CLLocationManager *manager, NSArray *locations) {
        return locations;
    }];
}

- (RACSignal<NSError *> *)didFailWithError
{
    return [[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)] reduceEach:^id(CLLocationManager *manager, NSError *error) {
        return error;
    }];
}

- (RACSignal<NSNumber *> *)didChangeAuthorizationStatus
{
    return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] reduceEach:^id(CLLocationManager *manager, NSNumber *status) {
        return status;
    }];
}

@end
