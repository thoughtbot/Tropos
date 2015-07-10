@interface UIColor (TRTemperatureColors)

+ (instancetype)defaultTextColor;
+ (instancetype)lightTextColor;

+ (instancetype)primaryBackgroundColor;
+ (instancetype)secondaryBackgroundColor;

+ (instancetype)hotColor;
+ (instancetype)warmerColor;
+ (instancetype)coolerColor;
+ (instancetype)coldColor;

- (instancetype)lighterColorByAmount:(CGFloat)amount;

@end
