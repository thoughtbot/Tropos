FOUNDATION_EXPORT NSString *const TRSettingsDidChangeNotification;

typedef NS_ENUM(NSInteger, TRUnitSystem) {
    TRUnitSystemMetric,
    TRUnitSystemImperial
};

@interface TRSettingsController : NSObject

- (void)registerSettings;

- (TRUnitSystem)unitSystem;
- (void)setUnitSystem:(TRUnitSystem)unitSystem;

@end
