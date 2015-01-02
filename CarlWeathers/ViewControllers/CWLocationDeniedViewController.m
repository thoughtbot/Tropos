#import "CWLocationDeniedViewController.h"
#import "CWLocationController.h"

@interface CWLocationDeniedViewController ()

@property (nonatomic) CWLocationController *locationController;

@end

@implementation CWLocationDeniedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationController = [CWLocationController new];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didBecomeActive:(NSNotification *)notification
{
    [self.locationController updateLocationWithCompletion:^(double latitude, double longitude) {
        [self dismissViewControllerAnimated:NO completion:nil];
    } errorBlock:nil];
}

@end
