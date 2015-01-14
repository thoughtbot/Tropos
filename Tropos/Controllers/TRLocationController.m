@import CoreLocation;
#import "TRLocationController.h"
#import "TRWeatherLocation.h"
#import "CLLocation+TRRecentLocation.h"

@interface TRLocationController () <CLLocationManagerDelegate>

@property (nonatomic, readwrite) TRLocationAuthorizationType authorizationType;
@property (nonatomic, copy) TRLocationAuthorizationChangedBlock authorizationChangedBlock;

@property (nonatomic) BOOL authorized;
@property (nonatomic, copy) TRLocationUpdateBlock completionBlock;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;

@end

@implementation TRLocationController

#pragma mark - Class Methods

+ (instancetype)controllerWithAuthorizationType:(TRLocationAuthorizationType)type authorizationChanged:(void (^)(BOOL))authChanged
{
    return [[TRLocationController alloc] initWithAuthorizationType:type authorizationChangedBlock:authChanged];
}

#pragma mark - Initializers

- (instancetype)initWithAuthorizationType:(TRLocationAuthorizationType)type authorizationChangedBlock:(TRLocationAuthorizationChangedBlock)block
{
    self = [self init];
    if (!self) return nil;

    self.authorizationType = type;
    self.authorizationChangedBlock = block;

    return self;
}

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    self.geocoder = [CLGeocoder new];

    return self;
}

#pragma mark - NSObject

- (void)dealloc
{
    [self cancel];
}

#pragma mark - Properties

- (BOOL)needsAuthorization
{
    return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined;
}

#pragma mark - Methods

- (void)requestAuthorization
{
    switch (self.authorizationType) {
        case TRLocationAuthorizationAlways:
            [self.locationManager requestAlwaysAuthorization];
            break;
        case TRLocationAuthorizationWhenInUse:
            [self.locationManager requestWhenInUseAuthorization];
            break;
    }
}

- (void)updateLocationWithBlock:(TRLocationUpdateBlock)completionBlock
{
    NSParameterAssert(completionBlock);

    self.completionBlock = completionBlock;

    if (!self.authorized) {
        self.completionBlock(nil, [NSError locationUnauthorizedError]);
        return;
    }

    [self.locationManager startUpdatingLocation];
}

- (void)cancel
{
    [self.locationManager stopUpdatingLocation];
    [self.geocoder cancelGeocode];
}

#pragma mark - Private

- (BOOL)authorized
{
    switch (self.authorizationType) {
        case TRLocationAuthorizationAlways:
            return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
        case TRLocationAuthorizationWhenInUse:
            return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations.lastObject;

    if (location.isStale) {
        return;
    }

    [self.locationManager stopUpdatingLocation];

    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!placemarks) {
            self.completionBlock(nil, error);
            return;
        }

        TRWeatherLocation *weatherLocation = [[TRWeatherLocation alloc] initWithPlacemark:placemarks.lastObject];
        self.completionBlock(weatherLocation, nil);
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [self.locationManager stopUpdatingLocation];
    self.completionBlock(nil, error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.authorizationChangedBlock) {
        self.authorizationChangedBlock(self.authorized);
    }
}

@end
