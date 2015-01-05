#import "UIColor+CWTemperatureColors.h"

@implementation UIColor (CWTemperatureColors)

+ (instancetype)defaultTextColor
{
    return [UIColor whiteColor];
}

+ (instancetype)hotColor
{
    return [UIColor colorWithHue:11.0 / 350.0 saturation:0.80 brightness:0.92 alpha:1.0];
}

+ (instancetype)warmerColor
{
    return [UIColor colorWithHue:40.0 / 350.0 saturation:1.0 brightness:0.97 alpha:1.0];
}

+ (instancetype)coolerColor
{
    return [UIColor colorWithHue:194.0 / 350.0 saturation:1 brightness:0.93 alpha:1.0];
}

+ (instancetype)coldColor
{
    return [UIColor colorWithHue:194.0 / 350.0 saturation:0.54 brightness:0.95 alpha:1.0];
}

@end
