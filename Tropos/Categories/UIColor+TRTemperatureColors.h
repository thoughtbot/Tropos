@interface UIColor (TRTemperatureColors)

+ (instancetype)defaultTextColor;
+ (instancetype)hotColor;
+ (instancetype)warmerColor;
+ (instancetype)coolerColor;
+ (instancetype)coldColor;

- (instancetype)lighterColorByAmount:(CGFloat)amount;

@end
