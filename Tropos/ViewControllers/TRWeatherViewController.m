#import "TRWeatherViewController.h"
#import "TRWeatherController.h"
#import "TRWeatherViewModel.h"
#import "TRWeatherStatusViewModel.h"
#import "TRPrecipitationMeterView.h"

@interface TRWeatherViewController ()

@property (nonatomic) TRWeatherController *controller;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *conditionsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windSpeedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;
@property (weak, nonatomic) IBOutlet TRPrecipitationMeterView *precipitationMeterView;

@end

@implementation TRWeatherViewController

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.controller = [TRWeatherController new];
    RAC(self.cityLabel, text) = [self.controller locationName];
    RAC(self.lastUpdatedLabel, text) = [self.controller status];
    [self.KVOController observe:self.controller keyPath:@"weatherViewModel" options:(NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew) action:@selector(viewModelDidChange:object:)];
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

- (void)viewModelDidChange:(NSDictionary *)changes object:(TRWeatherController *)controller
{
    self.conditionsImageView.image = controller.weatherViewModel.conditionsImage;
    self.highLowTemperatureLabel.text = controller.weatherViewModel.formattedTemperatureRange;
    self.windSpeedLabel.text = controller.weatherViewModel.formattedWindSpeed;
    self.precipitationMeterView.precipitationProbability = controller.weatherViewModel.precipitationProbability;
    self.conditionsDescriptionLabel.attributedText = controller.weatherViewModel.attributedTemperatureComparison;
}

@end
