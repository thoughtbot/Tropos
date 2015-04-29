#import "UIColor+TRTemperatureColors.h"

@implementation UIColor (TRTemperatureColors)

+ (instancetype)defaultTextColor
{
    return [UIColor whiteColor];
}

+ (instancetype)lightTextColor
{
    return [UIColor colorWithHue:240.0f / 360.0f saturation:0.02f brightness:0.8f alpha:1.0f];
}

+ (instancetype)primaryBackgroundColor
{
    return [UIColor colorWithHue:240.0f / 360.0f saturation:0.24f brightness:0.13f alpha:1.0f];
}

+ (instancetype)secondaryBackgroundColor
{
    return [UIColor colorWithHue:240.0f / 360.0f saturation:0.22f brightness:0.16f alpha:1.0f];
}

+ (instancetype)hotColor
{
    return [UIColor colorWithHue:11.0f / 360.0f saturation:0.80f brightness:0.92f alpha:1.0f];
}

+ (instancetype)warmerColor
{
    return [UIColor colorWithHue:40.0f / 360.0f saturation:1.0f brightness:0.97f alpha:1.0f];
}

+ (instancetype)coolerColor
{
    return [UIColor colorWithHue:194.0f / 360.0f saturation:1.0f brightness:0.93f alpha:1.0f];
}

+ (instancetype)coldColor
{
    return [UIColor colorWithHue:194.0f / 360.0f saturation:0.54f brightness:0.95f alpha:1.0f];
}

- (instancetype)lighterColorByAmount:(CGFloat)amount
{
    CGFloat hue, saturation, brightness, alpha;
    [self getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];

    CGFloat newSaturation = saturation * (1 - amount);
    CGFloat newBrightness = brightness * (1 - amount) + amount;

    return [UIColor colorWithHue:hue saturation:newSaturation brightness:newBrightness alpha:alpha];
}

@end
