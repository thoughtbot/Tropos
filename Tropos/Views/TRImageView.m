#import "TRImageView.h"
#import "CATransition+TRFadeTransition.h"

@implementation TRImageView

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    [self.layer setValue:image forKey:NSStringFromSelector(_cmd)];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    NSString *imageKey = NSStringFromSelector(@selector(setImage:));

    if ([event isEqualToString:imageKey]) {
        return [CATransition fadeTransition];
    }

    return [super actionForLayer:layer forKey:event];
}

@end
