#import "TRRefreshLayer.h"
#import "Tropos-Swift.h"

@implementation TRRefreshLayer

+ (instancetype)layerWithMask:(CALayer *)mask
{
    TRRefreshLayer *layer = [self layer];
    layer.mask = mask;
    return layer;
}

- (instancetype)init
{
    self = [super init];

    self.actions = @{@"bounds": [NSNull null], @"position": [NSNull null]};
    self.backgroundColor = [[UIColor secondaryBackgroundColor] CGColor];

    return self;
}

@end
