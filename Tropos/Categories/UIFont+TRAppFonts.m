#import "UIFont+TRAppFonts.h"

@implementation UIFont (TRAppFonts)

+ (UIFont *)defaultLightFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"DINNextLTPro-Light" size:fontSize];
}

+ (instancetype)defaultRegularFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"DINNextLTPro-Regular" size:fontSize];
}

@end
