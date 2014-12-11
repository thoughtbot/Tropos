#import "CWLocationController.h"
#import "CWWeatherViewController.h"

@interface CWWeatherViewController ()

@property (nonatomic) CWLocationController *locationController;

@end

@implementation CWWeatherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationController = [CWLocationController new];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refresh];
}

- (void)refresh
{
    [self.locationController updateLocationWithCompletion:^(double latitude,
                                                            double longitude)
    {
        NSLog(@"Update block %f %f", latitude, longitude);
    } errorBlock:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

@end
