#import "TRColorBackdropLayer.h"
#import "UIImage+TRColorBackdrop.h"

static NSString *const TRColorBackdropLayerAnimationKey = @"TRColorBackdropLayerAnimationKey";

@implementation TRColorBackdropLayer

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.actions = @{@"bounds": [NSNull null], @"position": [NSNull null]};
    self.backgroundColor = [[UIColor colorWithPatternImage:[UIImage colorBackdropImage]] CGColor];

    return self;
}

#pragma mark - API

- (void)startAnimating
{
    [self addAnimation:[self positionAnimation] forKey:TRColorBackdropLayerAnimationKey];
}

- (void)stopAnimating
{
    [self removeAnimationForKey:TRColorBackdropLayerAnimationKey];
}

#pragma mark - Private

- (CABasicAnimation *)positionAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.toValue = @(self.position.x - 80.0f);
    animation.repeatCount = HUGE_VALF;
    animation.duration = 0.5;
    return animation;
}

@end
