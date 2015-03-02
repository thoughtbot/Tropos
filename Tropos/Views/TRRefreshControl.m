#import "TRRefreshControl.h"
#import "TRRefreshView.h"
#import "UIScrollView+TRReactiveCocoa.h"

@interface TRRefreshControl ()

@property (nonatomic) IBOutlet TRRefreshView *refreshView;
@property (nonatomic) IBOutlet NSLayoutConstraint *refreshViewHeightConstraint;
@property (nonatomic) RACDisposable *commandExecutionDisposable;

@end

@implementation TRRefreshControl

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];

    RAC(self, refreshViewHeightConstraint.constant) = [self refreshViewHeight];
    RAC(self, refreshView.animating) = [self animating];
    RAC(self, refreshView.progress) = [self progress];
    RAC(self, refreshView.maskExpansionProgress) = [self maskExpansionProgress];

    [self rac_liftSelector:@selector(setContentInsets:) withSignals:[self contentInsets], nil];

    @weakify(self)
    [[[self refreshTriggered] ignore:@NO] subscribeNext:^(id x) {
        @strongify(self)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }];
}

#pragma mark - Properties

- (void)setRefreshCommand:(RACCommand *)command
{
    _refreshCommand = command;
    [self.commandExecutionDisposable dispose];

    if (!command) return;

    self.commandExecutionDisposable = [[[[self rac_signalForControlEvents:UIControlEventValueChanged]
    map:^id(TRRefreshControl *control) {
        return [[[command execute:control]
        catchTo:[RACSignal empty]]
        then:^RACSignal *{
            return [RACSignal return:control];
        }]
        ;
    }]
    concat]
    subscribeNext:^(TRRefreshControl *control) {
        [control endRefreshing];
    }];
    ;
}

#pragma mark - Private

- (void)endRefreshing
{
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)setContentInsets:(UIEdgeInsets)insets
{
    if (UIEdgeInsetsEqualToEdgeInsets(insets, self.scrollView.contentInset)) return;
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    self.scrollView.contentInset = insets;
    self.scrollView.contentOffset = contentOffset;
}

#pragma mark - Signals

- (RACSignal *)refreshViewHeight
{
    return [[self.scrollView verticalAmountScrolledSignal]
    filter:^BOOL(NSNumber *amountScrolled) {
        return amountScrolled.floatValue >= 0.0f;
    }]
    ;
}

- (RACSignal *)refreshThresholdProgress
{
    @weakify(self)
    return [[self.scrollView verticalAmountScrolledSignal]
    map:^id(NSNumber *amountScrolled) {
        @strongify(self)
        CGFloat scrollOffset = amountScrolled.floatValue - self.refreshProgressOffset;
        CGFloat targetOffset = self.refreshTriggerOffset - self.refreshProgressOffset;
        return @(scrollOffset / targetOffset);
    }]
    ;
}

- (RACSignal *)refreshThresholdReached
{
    @weakify(self)
    return [[[self.scrollView verticalAmountScrolledSignal]
    map:^id(NSNumber *amountScrolled) {
        @strongify(self)
        return @(amountScrolled.floatValue >= self.refreshTriggerOffset);
    }]
    distinctUntilChanged]
    ;
}

- (RACSignal *)progress
{
    return [RACSignal combineLatest:@[[self refreshThresholdProgress], [self refreshTriggered]] reduce:^id(NSNumber *progress, NSNumber *refreshTriggered) {
        return (refreshTriggered.boolValue)? @1.0f : progress;
    }]
    ;
}

- (RACSignal *)animating
{
    return [[[self progress]
    map:^id(NSNumber *progress) {
        return @(progress.floatValue >= 1.0f);
    }]
    distinctUntilChanged]
    ;
}

- (RACSignal *)refreshTriggered
{
    return [[[RACSignal
    combineLatest:@[[self refreshThresholdReached], [self.scrollView deceleratingSignal], [self refreshViewHidden]]]
    scanWithStart:@NO
    reduce:^id(NSNumber *previouslyTriggered, RACTuple *next) {
        BOOL refreshThresholdReached = [next.first boolValue];
        BOOL decelerating = [next.second boolValue];
        BOOL hidden = [next.third boolValue];

        if (hidden) return @NO;
        if (previouslyTriggered.boolValue) return @YES;

        return @(refreshThresholdReached && decelerating);
    }]
    distinctUntilChanged]
    ;
}

- (RACSignal *)maskExpansionProgress
{
    RACSignal *maskExpansionProgress = [[self refreshThresholdProgress] map:^id(NSNumber *progress) {
        return @(1.0f - progress.floatValue);
    }];

    return [RACSignal combineLatest:@[maskExpansionProgress, [self refreshTriggered]] reduce:^id(NSNumber *progress, NSNumber *refreshTriggered) {
        if (refreshTriggered.boolValue) return progress;
        return @0.0f;
    }]
    ;
}

- (RACSignal *)refreshViewHidden
{
    return [[self.scrollView verticalAmountScrolledSignal] map:^id(NSNumber *amountScrolled) {
        return @(amountScrolled.floatValue <= 0.0f);
    }];
}

- (RACSignal *)contentInsets
{
    return [[self refreshTriggered]
    map:^id(NSNumber *triggered) {
        UIEdgeInsets insets = triggered.boolValue? UIEdgeInsetsMake(4.0f, 0.0f, 0.0f, 0.0f) : UIEdgeInsetsZero;
        return [NSValue valueWithUIEdgeInsets:insets];
    }]
    ;
}

@end
