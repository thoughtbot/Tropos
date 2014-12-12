#import "CWLocationController.h"
#import "CWWeatherViewController.h"
#import "CWForecastClient.h"
#import "CWCurrentConditions.h"
@import CoreLocation;

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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *precipitationMeterViewTopConstraint;

@end

@implementation CWWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationController = [CWLocationController new];
    self.forecastClient = [CWForecastClient new];
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
        [self.forecastClient fetchCurrentConditionsAtLatitude:latitude longitude:longitude completion:^(CWCurrentConditions *currentConditions) {
            // Set condition labels
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
