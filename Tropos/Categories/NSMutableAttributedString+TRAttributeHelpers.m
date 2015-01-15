#import "NSMutableAttributedString+TRAttributeHelpers.h"

@implementation NSMutableAttributedString (TRAttributeHelpers)

- (void)setTextColor:(UIColor *)color
{
    [self setTextColor:color forRange:[self entireRange]];
}

- (void)setTextColor:(UIColor *)color forSubstring:(NSString *)substring
{
    [self setTextColor:color forRange:[self.string rangeOfString:substring]];
}

- (void)setTextColor:(UIColor *)color forRange:(NSRange)range
{
    [self setAttributes:@{NSForegroundColorAttributeName: color} range:range];
}

- (void)setFont:(UIFont *)font
{
    [self setAttributes:@{NSFontAttributeName: font} range:[self entireRange]];
}

- (void)setLineHeightMultiple:(CGFloat)multiple spacing:(CGFloat)spacing
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = multiple;
    paragraphStyle.lineSpacing = spacing;

    [self setAttributes:@{NSParagraphStyleAttributeName: paragraphStyle} range:[self entireRange]];
}

- (NSRange)entireRange
{
    return NSMakeRange(0, self.string.length);
}

@end
