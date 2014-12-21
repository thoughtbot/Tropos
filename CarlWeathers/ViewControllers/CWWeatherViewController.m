#import "CWWeatherViewController.h"
#import "CWWeatherController.h"
#import "CWWeatherViewModel.h"
#import "CWLocationController.h"

@interface CWWeatherViewController ()

@property (nonatomic) CWWeatherController *controller;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *conditionsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windSpeedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *precipitationMeterViewWidthConstraint;

@end

@implementation CWWeatherViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [CWWeatherController new];
    [self.KVOController observe:self.controller keyPath:@"viewModel" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) action:@selector(controllerDidChange:object:)];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Actions

- (IBAction)refresh
{
    [self.controller updateWeather];
}

#pragma mark - Private

- (void)controllerDidChange:(NSDictionary *)changes object:(CWWeatherController *)controller
{
    self.cityLabel.text = controller.viewModel.locationName;
    self.coordinateLabel.text = controller.viewModel.formattedCoordinate;
    self.conditionsImageView.image = controller.viewModel.conditionsImage;
    self.highLowTemperatureLabel.text = controller.viewModel.formattedTemperatureRange;
    self.windSpeedLabel.text = controller.viewModel.formattedWindSpeed;
    self.conditionsDescriptionLabel.attributedText = controller.viewModel.attributedTemperatureComparison;
}

@end
