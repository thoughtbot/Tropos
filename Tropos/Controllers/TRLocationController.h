@class TRWeatherLocation;

typedef void (^TRLocationUpdateBlock)(TRWeatherLocation *weatherLocation, NSError *error);
typedef void (^TRLocationAuthorizationChangedBlock)(BOOL authorized);

typedef NS_ENUM(NSUInteger, TRLocationAuthorizationType) {
    TRLocationAuthorizationAlways,
    TRLocationAuthorizationWhenInUse
};

@interface TRLocationController : NSObject

@property (nonatomic, readonly) TRLocationAuthorizationType authorizationType;
@property (nonatomic) BOOL needsAuthorization;

+ (instancetype)controllerWithAuthorizationType:(TRLocationAuthorizationType)type authorizationChanged:(TRLocationAuthorizationChangedBlock)authorizationChanged;

- (void)requestAuthorization;
- (void)updateLocationWithBlock:(TRLocationUpdateBlock)completionBlock;
- (void)cancel;

@end
