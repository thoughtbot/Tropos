#import "Tropos-Swift.h"

@interface TRAnalyticsController : NSObject

+ (instancetype)sharedController;
- (void)install;
- (void)trackEventNamed:(NSString *)eventName;
- (void)trackEvent:(id<AnalyticsEvent>)event;
- (void)trackError:(NSError *)error eventName:(NSString *)eventName;

@end
