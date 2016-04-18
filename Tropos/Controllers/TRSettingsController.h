#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

FOUNDATION_EXPORT NSString *const TRSettingsDidChangeNotification;
FOUNDATION_EXPORT NSString *const TRSettingsLastVersionKey;
FOUNDATION_EXPORT NSString *const TRSettingsUnitSystemKey;

typedef NS_ENUM(NSInteger, TRUnitSystem) {
    TRUnitSystemMetric,
    TRUnitSystemImperial
};

@interface TRSettingsController : NSObject

@property (nonatomic, readonly) RACSignal *unitSystemChanged;

- (instancetype)initWithLocale:(NSLocale *)locale NS_DESIGNATED_INITIALIZER;

- (void)registerSettings;

- (TRUnitSystem)unitSystem;
- (void)setUnitSystem:(TRUnitSystem)unitSystem;

@end
