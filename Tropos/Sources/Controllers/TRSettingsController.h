FOUNDATION_EXPORT NSString *const TRSettingsDidChangeNotification;

typedef NS_ENUM(NSInteger, TRUnitSystem) {
    TRUnitSystemMetric,
    TRUnitSystemImperial
};

@interface TRSettingsController : NSObject

@property (nonatomic, readonly) RACSignal *unitSystemChanged;
@property (nonatomic) TRUnitSystem unitSystem;

- (void)registerSettings;

@end
