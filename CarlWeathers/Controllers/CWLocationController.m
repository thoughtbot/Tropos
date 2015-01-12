@import CoreLocation;
#import "CWLocationController.h"
#import "CWWeatherLocation.h"
#import "CLLocation+CWRecentLocation.h"

@interface CWLocationController () <CLLocationManagerDelegate>

@property (nonatomic, readwrite) CWLocationAuthorizationType authorizationType;
@property (nonatomic, copy) CWLocationAuthorizationChangedBlock authorizationChangedBlock;

@property (nonatomic) BOOL authorized;
@property (nonatomic, copy) CWLocationUpdateBlock completionBlock;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLGeocoder *geocoder;

@end

@implementation CWLocationController

#pragma mark - Class Methods

+ (instancetype)controllerWithAuthorizationType:(CWLocationAuthorizationType)type authorizationChanged:(void (^)(BOOL))authChanged
{
    return [[CWLocationController alloc] initWithAuthorizationType:type authorizationChangedBlock:authChanged];
}

#pragma mark - Initializers

- (instancetype)initWithAuthorizationType:(CWLocationAuthorizationType)type authorizationChangedBlock:(CWLocationAuthorizationChangedBlock)block
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
        case CWLocationAuthorizationAlways:
            [self.locationManager requestAlwaysAuthorization];
            break;
        case CWLocationAuthorizationWhenInUse:
            [self.locationManager requestWhenInUseAuthorization];
            break;
    }
}

- (RACSignal *)currentLocation
{
    [self.locationManager startUpdatingLocation];
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"Starting update");
        return [[[RACSignal merge:@[[self locationUpdate], [self locationUpdateError]]] take:1] subscribe:subscriber];
    }];
}

- (RACSignal *)locationUpdate
{
    return [[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)]
                                   reduceEach:^id(id _, NSArray *locations) {
                                       return locations.lastObject;
                                   }]
                                  filter:^BOOL(CLLocation *location) {
                                      return location.isStale == NO;
                                  }]
                                 doNext:^(id _) {
                                     [self.locationManager stopUpdatingLocation];
                                 }];
}

- (RACSignal *)locationUpdateError
{
    return [[[self rac_signalForSelector:@selector(locationManager:didFailWithError:) fromProtocol:@protocol(CLLocationManagerDelegate)] reduceEach:^id(id _, NSError *error) {
        return error;
    }] flattenMap:^RACStream *(NSError *error) {
        return [RACSignal error:error];
    }];
}


- (void)updateLocationWithBlock:(CWLocationUpdateBlock)completionBlock
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
        case CWLocationAuthorizationAlways:
            return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways;
        case CWLocationAuthorizationWhenInUse:
            return [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse;
    }
}

#pragma mark - CLLocationManagerDelegate

//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    CLLocation *location = locations.lastObject;
//
//    if (location.isStale) {
//        return;
//    }
//
//    [self.locationManager stopUpdatingLocation];
//
//    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//        if (!placemarks) {
//            self.completionBlock(nil, error);
//            return;
//        }
//
//        CWWeatherLocation *weatherLocation = [[CWWeatherLocation alloc] initWithPlacemark:placemarks.lastObject];
//        self.completionBlock(weatherLocation, nil);
//    }];
//}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
//{
//    [self.locationManager stopUpdatingLocation];
//    self.completionBlock(nil, error);
//}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (self.authorizationChangedBlock) {
        self.authorizationChangedBlock(self.authorized);
    }
}

@end
