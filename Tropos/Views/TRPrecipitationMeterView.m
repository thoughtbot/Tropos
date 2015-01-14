#import "TRPrecipitationMeterView.h"

@interface TRPrecipitationMeterView ()

@property (nonatomic) CALayer *meterFillLayer;

@end

@implementation TRPrecipitationMeterView

- (void)awakeFromNib
{
    [super awakeFromNib];

    self.meterFillLayer = [CALayer layer];
    self.meterFillLayer.anchorPoint = CGPointZero;
    self.meterFillLayer.bounds = self.bounds;
    self.meterFillLayer.position = CGPointZero;
    self.meterFillLayer.backgroundColor = [[UIColor coldColor] CGColor];
    [self.layer addSublayer:self.meterFillLayer];
}

- (void)setPrecipitationProbability:(CGFloat)precipitationProbability
{
    if (precipitationProbability == _precipitationProbability) {
        return;
    }

    _precipitationProbability = precipitationProbability;
    [self.layer setNeedsLayout];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if (layer != self.layer) {
        return;
    }

    CGRect bounds = self.meterFillLayer.bounds;
    bounds.size.width = CGRectGetWidth(self.bounds) * self.precipitationProbability;
    self.meterFillLayer.bounds = bounds;
}

@end
