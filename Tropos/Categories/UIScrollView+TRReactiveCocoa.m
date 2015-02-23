#import "UIScrollView+TRReactiveCocoa.h"

@implementation UIScrollView (TRReactiveCocoa)

- (RACSignal *)deceleratingSignal
{
    return [[RACObserve(self, contentOffset) map:^id(id value) {
        return @(self.decelerating);
    }]
    distinctUntilChanged]
    ;
}

- (RACSignal *)verticalAmountScrolledSignal
{
    return [[RACObserve(self, contentOffset) map:^id(NSValue *contentOffset) {
        CGFloat yOffset = floor(contentOffset.CGPointValue.y);
        return @(fabs(yOffset));
    }]
    distinctUntilChanged]
    ;
}

@end
