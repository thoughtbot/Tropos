#import "NSMutableAttributedString+CWAttributeHelpers.h"

@implementation NSMutableAttributedString (CWAttributeHelpers)

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

- (NSRange)entireRange
{
    return NSMakeRange(0, self.string.length);
}

@end
