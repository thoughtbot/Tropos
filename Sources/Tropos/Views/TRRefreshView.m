#import "TRRefreshView.h"
#import "TRCircularProgressLayer.h"
#import "TRColorBackdropLayer.h"
#import "TRRefreshLayer.h"

@interface TRRefreshView ()

@property (nonatomic) TRColorBackdropLayer *backdropLayer;
@property (nonatomic) TRRefreshLayer *refreshLayer;
@property (nonatomic) TRCircularProgressLayer *progressLayer;

@end

@implementation TRRefreshView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;

    [self.layer addSublayer:self.backdropLayer];
    [self.layer addSublayer:self.refreshLayer];

    return self;
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backdropLayer.frame = ({
        CGRect bounds = self.bounds;
        bounds.size.width *= 2.0f;
        bounds;
    });
    self.refreshLayer.frame = self.bounds;
    self.progressLayer.frame = self.bounds;
}

#pragma mark - API

- (void)setProgress:(CGFloat)progress
{
    self.progressLayer.progress = progress;
}

- (void)setMaskExpansionProgress:(CGFloat)maskExpansionProgress
{
    maskExpansionProgress = MAX(0.0f, MIN(maskExpansionProgress, 1.0f));
    CGFloat radiusDelta = (CGRectGetWidth(self.bounds) / 2.0f + self.progressLayer.outerRingWidth) - 15.0f;
    self.progressLayer.radius = (CGFloat)ceil(radiusDelta * maskExpansionProgress) + 15.0f;
}

- (void)setAnimating:(BOOL)animating
{
    if (animating == _animating) return;
    _animating = animating;
    (_animating)? [self startAnimating] : [self stopAnimating];
}

#pragma mark - Private

- (TRColorBackdropLayer *)backdropLayer
{
    if (!_backdropLayer) _backdropLayer = [TRColorBackdropLayer layer];
    return _backdropLayer;
}

- (TRCircularProgressLayer *)progressLayer
{
    if (!_progressLayer) _progressLayer = [TRCircularProgressLayer layer];
    return _progressLayer;
}

- (TRRefreshLayer *)refreshLayer
{
    if (!_refreshLayer) _refreshLayer = [TRRefreshLayer layerWithMask:self.progressLayer];
    return _refreshLayer;
}

- (void)startAnimating
{
    [self.backdropLayer startAnimating];
}

- (void)stopAnimating
{
    [self.backdropLayer stopAnimating];
}

@end
