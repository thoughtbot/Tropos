@import CoreLocation;
#import "CWCurrentConditions.h"
#import "CWForecastClient.h"
#import "CWHistoricalConditions.h"
#import "CWLocationController.h"
#import "CWTemperature.h"
#import "CWWeatherViewController.h"

@interface CWWeatherViewController ()

@property (nonatomic) CWLocationController *locationController;
@property (nonatomic) CWForecastClient *forecastClient;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationController = [CWLocationController new];
    self.forecastClient = [CWForecastClient new];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.conditionsDescriptionLabel.text = nil;
    self.windSpeedLabel.text = nil;
    self.highLowTemperatureLabel.text = nil;
    self.cityLabel.text = nil;
    self.coordinateLabel.text = nil;
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

- (NSAttributedString *)descriptionStringWithKey:(NSString *)key color:(UIColor *)color
{
    NSString *formatString = NSLocalizedString(@"relative temperature", nil);
    NSString *conditionString = NSLocalizedString(key, nil);
    NSString *descriptionString = [NSString stringWithFormat:formatString, conditionString];
    NSRange conditionRange = [descriptionString rangeOfString:conditionString];
    NSRange entireRange = NSMakeRange(0, descriptionString.length);
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:descriptionString];
    [as addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:entireRange];
    [as addAttribute:NSForegroundColorAttributeName value:color range:conditionRange];
    [as addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINNextLTPro-UltraLight" size:37] range:entireRange];
    return as;
}

- (IBAction)refresh
{
    [self.locationController updateLocationWithCompletion:^(double latitude,
                                                            double longitude)
    {
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
        CLGeocoder *geocoder = [CLGeocoder new];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *lastPlacemark = [placemarks lastObject];
            self.cityLabel.text = [[NSString stringWithFormat:@"%@, %@", lastPlacemark.locality, lastPlacemark.administrativeArea] uppercaseString];
        }];
        [self.forecastClient fetchConditionsAtLatitude:latitude longitude:longitude completion:^(CWCurrentConditions *currentConditions, CWHistoricalConditions *yesterdaysConditions) {
//            self.temperatureLabel.text = [NSString stringWithFormat:@"%@", currentConditions.temperature];
            self.conditionsImageView.image = [UIImage imageNamed:currentConditions.conditionsDescription];
            CWTemperature *currentTemperature = currentConditions.temperature;
            CWTemperature *yesterdaysTemperature = yesterdaysConditions.temperature;
            CWTemperatureComparison comparison = [currentTemperature compare:yesterdaysTemperature];
            NSAttributedString *description;
            switch (comparison) {
                case CWTemperatureComparisonHotter:
                    description = [self descriptionStringWithKey:@"hotter" color:[UIColor redColor]];
                    break;
                case CWTemperatureComparisonWarmer:
                    description = [self descriptionStringWithKey:@"warmer" color:[UIColor orangeColor]];
                    break;
                case CWTemperatureComparisonCooler:
                    description = [self descriptionStringWithKey:@"cooler" color:[UIColor blueColor]];
                    break;
                case CWTemperatureComparisonColder:
                    description = [self descriptionStringWithKey:@"colder" color:[UIColor purpleColor]];
                    break;
                case CWTemperatureComparisonSame:
                default:
                    description = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"same", nil)];
                    break;
            }

            self.conditionsDescriptionLabel.attributedText = description;
            CGFloat newWidth = CGRectGetWidth(self.view.bounds) * currentConditions.precipitationProbability;
            self.precipitationMeterViewWidthConstraint.constant = newWidth;
            [self.view layoutIfNeeded];
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
