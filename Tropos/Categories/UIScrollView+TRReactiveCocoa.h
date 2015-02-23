@interface UIScrollView (TRReactiveCocoa)

@property (nonatomic, readonly) RACSignal *verticalAmountScrolledSignal;
@property (nonatomic, readonly) RACSignal *deceleratingSignal;

@end
