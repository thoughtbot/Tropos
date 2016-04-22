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
        CGFloat yOffset = (CGFloat)floor(contentOffset.CGPointValue.y);
        return @(-1 * yOffset);
    }]
    distinctUntilChanged]
    ;
}

- (BOOL)isScrolledToBottom
{
    return (self.contentOffset.y == self.contentSize.height - CGRectGetHeight(self.bounds));
}

@end
