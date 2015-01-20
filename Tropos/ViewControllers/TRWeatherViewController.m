#import "TRWeatherViewController.h"
#import "TRWeatherViewModel.h"
#import "TRWeatherViewModel.h"
#import "TRPrecipitationMeterView.h"

@interface TRWeatherViewController ()

@property (nonatomic) TRWeatherViewModel *viewModel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *conditionsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windSpeedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;

@end

@implementation TRWeatherViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.viewModel = [TRWeatherViewModel new];
    RAC(self.cityLabel, text) = self.viewModel.locationName;
    RAC(self.lastUpdatedLabel, text) = self.viewModel.status;
    RAC(self.conditionsImageView, image) = self.viewModel.conditionsImage;
    RAC(self.conditionsDescriptionLabel, attributedText) = self.viewModel.conditionsDescription;
    RAC(self.windSpeedLabel, text) = self.viewModel.windDescription;
    RAC(self.highLowTemperatureLabel, text) = self.viewModel.highLowTemperatureDescription;

    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        [self.viewModel updateWeather];
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.viewModel updateWeather];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
