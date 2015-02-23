@class TRRefreshView;

@interface TRRefreshControl : UIControl

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic) IBInspectable CGFloat refreshTriggerOffset;
@property (nonatomic) IBInspectable CGFloat refreshProgressOffset;

@property (nonatomic) RACCommand *refreshCommand;

@end
