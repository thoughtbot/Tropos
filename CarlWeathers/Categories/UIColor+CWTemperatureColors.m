#import "UIColor+CWTemperatureColors.h"

@implementation UIColor (CWTemperatureColors)

+ (instancetype)defaultTextColor
{
    return [UIColor whiteColor];
}

+ (instancetype)hotColor
{
    return [UIColor colorWithHue:360.0 / 40.0 saturation:1.0 brightness:0.97 alpha:1.0];
}

+ (instancetype)coldColor
{
    return [UIColor colorWithHue:194.0 / 350.0 saturation:1.0 brightness:0.93 alpha:1.0];
}

@end
