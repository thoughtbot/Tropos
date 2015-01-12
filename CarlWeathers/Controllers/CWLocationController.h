@class CWWeatherLocation;

typedef void (^CWLocationUpdateBlock)(CWWeatherLocation *weatherLocation, NSError *error);
typedef void (^CWLocationAuthorizationChangedBlock)(BOOL authorized);

typedef NS_ENUM(NSUInteger, CWLocationAuthorizationType) {
    CWLocationAuthorizationAlways,
    CWLocationAuthorizationWhenInUse
};

@interface CWLocationController : NSObject

@property (nonatomic, readonly) CWLocationAuthorizationType authorizationType;
@property (nonatomic) BOOL needsAuthorization;

+ (instancetype)controllerWithAuthorizationType:(CWLocationAuthorizationType)type authorizationChanged:(CWLocationAuthorizationChangedBlock)authorizationChanged;

- (void)requestAuthorization;
- (RACSignal *)currentLocation;
- (void)updateLocationWithBlock:(CWLocationUpdateBlock)completionBlock;
- (void)cancel;

@end
