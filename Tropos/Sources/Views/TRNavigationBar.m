#import "TRNavigationBar.h"

@implementation TRNavigationBar

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, self.barTintColor.CGColor);
    CGContextFillRect(context, rect);
}

@end
