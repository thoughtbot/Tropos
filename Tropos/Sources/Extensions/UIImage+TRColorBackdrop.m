@import TroposCore;
#import "UIImage+TRColorBackdrop.h"

@implementation UIImage (TRColorBackdrop)

+ (instancetype)colorBackdropImage
{
    static UIImage *image;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *colors = @[[UIColor hotColor], [UIColor warmerColor], [UIColor coldColor], [UIColor coolerColor]];
        CGFloat columnWidth = 20.0f;

        CGFloat imageWidth;
        CGFloat imageHeight;
        imageWidth = imageHeight = columnWidth * colors.count;
        
        CGFloat yOffset = columnWidth / 2.0f;
        CGFloat topY = -yOffset;
        CGFloat bottomY = imageHeight + yOffset;
        CGFloat xOffset = imageHeight + columnWidth;
        
        CGSize contextSize = CGSizeMake(imageWidth, imageHeight);
        UIGraphicsBeginImageContextWithOptions(contextSize, YES, 0.0f);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, columnWidth);
        CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, imageHeight));
        
        NSInteger index = 0;
        
        while (index * columnWidth - xOffset <= imageWidth) {
            UIColor *color = colors[(NSUInteger)index % colors.count];
            CGContextSetStrokeColorWithColor(context, color.CGColor);
            
            NSInteger x = index * (NSInteger)columnWidth;
            CGContextMoveToPoint(context, x - xOffset, bottomY);
            CGContextAddLineToPoint(context, x, topY);
            CGContextStrokePath(context);
            index++;
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        image = [image resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile];
    });

    return image;
}

@end
