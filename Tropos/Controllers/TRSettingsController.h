#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

FOUNDATION_EXPORT NSString *const TRSettingsDidChangeNotification;

typedef NS_ENUM(NSInteger, TRUnitSystem) {
    TRUnitSystemMetric,
    TRUnitSystemImperial
};

@interface TRSettingsController : NSObject

@property (nonatomic, readonly) RACSignal *unitSystemChanged;

- (void)registerSettings;

- (TRUnitSystem)unitSystem;
- (void)setUnitSystem:(TRUnitSystem)unitSystem;

@end
