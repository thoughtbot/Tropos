@import TroposCore;
#import "TRDailyForecastView.h"

@interface TRDailyForecastView ()

@property (weak, nonatomic) IBOutlet UILabel *dayOfWeekLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *highTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *lowTemperatureLabel;
@property (strong, nonatomic) IBOutlet TRDailyForecastView *contentView;

@end

@implementation TRDailyForecastView

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
}

- (void)setViewModel:(TRDailyForecastViewModel *)viewModel
{
    _viewModel = viewModel;
    self.dayOfWeekLabel.text = viewModel.dayOfWeek;
    self.conditionsImageView.image = viewModel.conditionsImage;
    self.highTemperatureLabel.text = viewModel.highTemperature;
    self.lowTemperatureLabel.text = viewModel.lowTemperature;
}

@end
