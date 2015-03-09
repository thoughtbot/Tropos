@interface NSMutableAttributedString (TRAttributeHelpers)

- (void)setTextColor:(UIColor *)color;
- (void)setTextColor:(UIColor *)color forSubstring:(NSString *)substring;
- (void)setTextColor:(UIColor *)color forRange:(NSRange)range;
- (void)setFont:(UIFont *)font;
- (void)setLineHeightMultiple:(CGFloat)multiple spacing:(CGFloat)spacing;

@end
