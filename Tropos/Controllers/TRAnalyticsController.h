#import "TRAnalyticsEvent.h"

@interface TRAnalyticsController : NSObject

+ (instancetype)sharedController;
- (void)install;
- (void)trackEvent:(id<TRAnalyticsEvent>)event;
- (void)trackError:(NSError *)error eventName:(NSString *)eventName;

@end
