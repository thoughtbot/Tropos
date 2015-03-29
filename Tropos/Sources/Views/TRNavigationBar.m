#import "TRNavigationBar.h"

@interface TRNavigationBar () <UINavigationBarDelegate>
@end

@implementation TRNavigationBar

#pragma mark - NSObject

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.shadowImage = [UIImage new];
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
}

@end
