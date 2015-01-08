#import "CWWeatherViewController.h"
#import "CWWeatherController.h"
#import "CWWeatherViewModel.h"
#import "CWWeatherStatusViewModel.h"
#import "CWPrecipitationMeterView.h"

@interface CWWeatherViewController ()

@property (nonatomic) CWWeatherController *controller;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *conditionsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windSpeedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;
@property (weak, nonatomic) IBOutlet CWPrecipitationMeterView *precipitationMeterView;

@end

@implementation CWWeatherViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [CWWeatherController new];
    [self.KVOController observe:self.controller keyPath:@"weatherViewModel" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) action:@selector(viewModelDidChange:object:)];
    [self.KVOController observe:self.controller keyPath:@"statusViewModel" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) action:@selector(statusViewModelDidChange:object:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:UIApplicationWillEnterForegroundNotification object:nil];
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

- (void)viewModelDidChange:(NSDictionary *)changes object:(CWWeatherController *)controller
{
    self.conditionsImageView.image = controller.weatherViewModel.conditionsImage;
    self.highLowTemperatureLabel.text = controller.weatherViewModel.formattedTemperatureRange;
    self.windSpeedLabel.text = controller.weatherViewModel.formattedWindSpeed;
    self.conditionsDescriptionLabel.attributedText = controller.weatherViewModel.attributedTemperatureComparison;
    self.precipitationMeterView.precipitationProbability = controller.weatherViewModel.precipitationProbability;
}

- (void)statusViewModelDidChange:(NSDictionary *)changes object:(CWWeatherController *)controller
{
    self.cityLabel.text = controller.statusViewModel.location;
    self.lastUpdatedLabel.text = controller.statusViewModel.status;
}

@end
