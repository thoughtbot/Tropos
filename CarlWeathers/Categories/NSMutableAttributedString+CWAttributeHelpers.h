@interface NSMutableAttributedString (CWAttributeHelpers)

- (void)setTextColor:(UIColor *)color;
- (void)setTextColor:(UIColor *)color forSubstring:(NSString *)substring;
- (void)setFont:(UIFont *)font;

@end
