#import "UIColor+TRTemperatureColors.h"

@implementation UIColor (TRTemperatureColors)

+ (instancetype)defaultTextColor
{
    return [UIColor whiteColor];
}

+ (instancetype)hotColor
{
    return [UIColor colorWithHue:11.0f / 350.0f saturation:0.80f brightness:0.92f alpha:1.0f];
}

+ (instancetype)warmerColor
{
    return [UIColor colorWithHue:40.0f / 350.0f saturation:1.0f brightness:0.97f alpha:1.0f];
}

+ (instancetype)coolerColor
{
    return [UIColor colorWithHue:194.0f / 350.0f saturation:1.0f brightness:0.93f alpha:1.0f];
}

+ (instancetype)coldColor
{
    return [UIColor colorWithHue:194.0f / 350.0f saturation:0.54f brightness:0.95f alpha:1.0f];
}

@end
