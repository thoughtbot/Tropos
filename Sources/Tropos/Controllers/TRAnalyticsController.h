@import Foundation;
#import "TRAnalyticsEvent.h"

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(AnalyticsController)
@interface TRAnalyticsController : NSObject

@property (nonatomic, readonly, class) TRAnalyticsController *sharedController;

- (void)install;
- (void)trackEventNamed:(NSString *)eventName;
- (void)trackEvent:(id<TRAnalyticsEvent>)event;
- (void)trackError:(NSError *)error eventName:(NSString *)eventName;

@end

NS_ASSUME_NONNULL_END
