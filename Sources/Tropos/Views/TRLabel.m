#import "TRLabel.h"
#import "CATransition+TRFadeTransition.h"

@implementation TRLabel

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self.layer setValue:text forKey:NSStringFromSelector(_cmd)];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    [self.layer setValue:attributedText forKey:NSStringFromSelector(_cmd)];
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    NSString *textKey = NSStringFromSelector(@selector(setText:));
    NSString *attributedTextKey = NSStringFromSelector(@selector(setAttributedText:));

    if ([event isEqualToString:textKey] || [event isEqualToString:attributedTextKey]) {
        return [CATransition fadeTransition];
    }

    return [super actionForLayer:layer forKey:event];
}

@end
