@import CoreLocation;
#import "TRLocationController.h"
#import "TRWeatherLocation.h"
#import "CLLocation+TRRecentLocation.h"

@interface TRLocationController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation TRLocationController

#pragma mark - Initializers

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

#pragma mark - Properties

- (RACSignal *)requestWhenInUseAuthorization
{
    if ([self needsAuthorization]) {
        [self.locationManager requestWhenInUseAuthorization];
        return [self didAuthorize];
    } else {
        return [self authorized];
    }
}

- (RACSignal *)updateCurrentLocation
{
    RACSignal *currentLocationUpdated = [[[self didUpdateLocations] map:^id(NSArray *locations) {
        return locations.lastObject;
    }] filter:^BOOL(CLLocation *location) {
        return !location.isStale;
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

#pragma mark - Private

- (BOOL)needsAuthorization
{
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined);
}

- (RACSignal *)didAuthorize
{
    return [[[[self didChangeAuthorizationStatus] ignore:@(kCLAuthorizationStatusNotDetermined)] map:^id(NSNumber *status) {
        return @(status.integerValue == kCLAuthorizationStatusAuthorizedWhenInUse);
    }] take:1];
}

- (RACSignal *)authorized
{
    BOOL authorized = ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
    return [RACSignal return:@(authorized)];
}

#pragma mark - CLLocationManagerDelegate Signals

- (RACSignal *)didUpdateLocations
{
    return [[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)] reduceEach:^id(CLLocationManager *manager, NSArray *locations) {
        return locations;
    }];
}

- (RACSignal *)didFailWithError
{
    return [[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)] reduceEach:^id(CLLocationManager *manager, NSError *error) {
        return error;
    }];
}

- (RACSignal *)didChangeAuthorizationStatus
{
    return [[self rac_signalForSelector:@selector(locationManager:didChangeAuthorizationStatus:) fromProtocol:@protocol(CLLocationManagerDelegate)] reduceEach:^id(CLLocationManager *manager, NSNumber *status) {
        return status;
    }];
}

@end
