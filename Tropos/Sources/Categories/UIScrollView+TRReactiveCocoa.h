#import <ReactiveObjC/ReactiveObjC.h>
@import UIKit;

@interface UIScrollView (TRReactiveCocoa)

@property (nonatomic, readonly) RACSignal *verticalAmountScrolledSignal;
@property (nonatomic, readonly) RACSignal *deceleratingSignal;

@property (nonatomic, readonly) BOOL isScrolledToBottom;

@end
