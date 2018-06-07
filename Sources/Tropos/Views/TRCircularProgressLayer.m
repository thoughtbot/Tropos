#import "TRCircularProgressLayer.h"

static CGPoint TRCGPointMakeIntegral(CGFloat x, CGFloat y) {
    return CGPointMake((CGFloat)round(x), (CGFloat)round(y));
    
}

@implementation TRCircularProgressLayer

@dynamic progress, radius;

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (!self) return nil;

    self.actions = @{@"bounds": [NSNull null], @"contents": [NSNull null], @"position": [NSNull null]};
    self.contentsScale = [UIScreen mainScreen].scale;
    self.needsDisplayOnBoundsChange = YES;
    self.outerRingWidth = 3.0f;
    self.radius = 15.0f;

    return self;
}

- (instancetype)initWithLayer:(TRCircularProgressLayer *)layer
{
    self = [super initWithLayer:layer];
    if (!self) return nil;
    if (![layer isKindOfClass:[TRCircularProgressLayer class]]) return self;

    self.progress = layer.progress;
    self.radius = layer.radius;

    return self;
}

#pragma mark - CALayer

- (void)drawInContext:(CGContextRef)context
{
    CGPoint center = TRCGPointMakeIntegral(CGRectGetWidth(self.bounds) / 2.0f, CGRectGetHeight(self.bounds) / 2.0f);

    CGFloat progress = MIN(self.progress, 1.0f - FLT_EPSILON);
    CGFloat radians = (progress * (CGFloat)M_PI * 2.0f) - (CGFloat)M_PI_2;

    CGContextSetFillColorWithColor(context, self.backgroundColor);
    CGContextFillRect(context, self.bounds);

    CGContextSetBlendMode(context, kCGBlendModeClear);

    CGContextSetLineWidth(context, self.outerRingWidth);
    CGContextSetStrokeColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextAddArc(context, center.x, center.y, self.radius, 0.0f, (CGFloat)M_PI * 2, YES);
    CGContextStrokePath(context);

    if (progress > 0.0f) {
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGMutablePathRef progressPath = CGPathCreateMutable();
        CGPathMoveToPoint(progressPath, NULL, center.x, center.y);
        CGPathAddArc(progressPath, NULL, center.x, center.y, self.radius, 3.0f * (CGFloat)M_PI_2, radians, false);
        CGPathCloseSubpath(progressPath);
        CGContextAddPath(context, progressPath);
        CGContextFillPath(context);
        CGPathRelease(progressPath);
    }
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([[self animatableKeys] containsObject:key]) {
        return YES;
    }

    return [super needsDisplayForKey:key];
}

#pragma mark - Private

+ (NSSet *)animatableKeys
{
    static NSSet *keys;

    if (!keys) {
        NSString *progressKey = NSStringFromSelector(@selector(progress));
        NSString *maskRadiusKey = NSStringFromSelector(@selector(radius));
        NSString *outerRingWidthKey = NSStringFromSelector(@selector(outerRingWidth));
        keys = [[NSSet alloc] initWithObjects:progressKey, maskRadiusKey, outerRingWidthKey, nil];
    }

    return keys;
}

@end
