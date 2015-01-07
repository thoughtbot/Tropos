FOUNDATION_EXPORT NSString *const CWSettingsDidChangeNotification;

typedef NS_ENUM(NSInteger, CWUnitSystem) {
    CWUnitSystemMetric,
    CWUnitSystemImperial
};

@interface CWSettingsController : NSObject

- (void)registerSettings;

- (CWUnitSystem)unitSystem;
- (void)setUnitSystem:(CWUnitSystem)unitSystem;

@end
