#import "CATransition+TRFadeTransition.h"

@implementation CATransition (TRFadeTransition)

+ (instancetype)fadeTransition
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFade;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return transition;
}

@end
