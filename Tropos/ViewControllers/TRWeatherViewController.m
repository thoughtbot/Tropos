#import "TRWeatherViewController.h"
#import "TRWeatherViewModel.h"
#import "TRWeatherViewModel.h"
#import "TRPrecipitationMeterView.h"
#import "TRDailyForecastView.h"
#import "TRRefreshControl.h"
#import "TRAnalyticsController.h"
#import "UIScrollView+TRReactiveCocoa.h"

@interface TRWeatherViewController () <UIScrollViewDelegate>

@property (nonatomic) TRWeatherViewModel *viewModel;
@property (strong, nonatomic) IBOutlet TRRefreshControl *refreshControl;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (weak, nonatomic) IBOutlet UIImageView *conditionsImageView;
@property (weak, nonatomic) IBOutlet UILabel *conditionsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *highLowTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *windSpeedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *temperatureImageView;

@property (weak, nonatomic) IBOutlet TRDailyForecastView *oneDayForecastView;
@property (weak, nonatomic) IBOutlet TRDailyForecastView *twoDayForecastView;
@property (weak, nonatomic) IBOutlet TRDailyForecastView *threeDayForecastView;

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
    RAC(self.windSpeedImageView, hidden) = [self.viewModel.windDescription map:^id(id value) {
        return @(value == nil);
    }];
    RAC(self.highLowTemperatureLabel, text) = self.viewModel.highLowTemperatureDescription;
    RAC(self.temperatureImageView, hidden) = [self.viewModel.highLowTemperatureDescription map:^id(id value) {
        return @(value == nil);
    }];

    self.refreshControl.refreshCommand = self.viewModel.updateWeatherCommand;

    self.scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    RAC(self, scrollView.scrollEnabled) = [self.viewModel.updateWeatherCommand.executing not];

    NSArray *forecastViews = @[self.oneDayForecastView, self.twoDayForecastView, self.threeDayForecastView];
    [self.viewModel.dailyForecastViewModels subscribeNext:^(NSArray *viewModels) {
        [forecastViews enumerateObjectsUsingBlock:^(TRDailyForecastView *view, NSUInteger index, BOOL *stop) {
            view.viewModel = viewModels[index];
        }];
    }];

    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel.updateWeatherCommand execute:self];
    }];

    [self configureAnalytics];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.viewModel.updateWeatherCommand execute:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Analytics

- (void)configureAnalytics
{
    RACSignal *viewedForecast = [[[RACSignal merge:@[[self scrollViewDidEndDecelerating], [self scrollViewDidEndDragging]]]
    filter:^BOOL(UIScrollView *scrollView) {
        return scrollView.isScrolledToBottom;
    }]
    mapReplace:@"Viewed Forecast"];

    [[TRAnalyticsController sharedController] rac_liftSelector:@selector(trackEventNamed:) withSignals:viewedForecast, nil];
}

#pragma mark - UIScrollViewDelegate Signals

- (RACSignal *)scrollViewDidEndDecelerating
{
    return [[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)]
    reduceEach:^id(UIScrollView *scrollView) {
        return scrollView;
    }];
}

- (RACSignal *)scrollViewDidEndDragging
{
    return [[[self rac_signalForSelector:@selector(scrollViewDidEndDragging:willDecelerate:) fromProtocol:@protocol(UIScrollViewDelegate)]
    filter:^BOOL(RACTuple *arguments) {
        return ([arguments.second boolValue] == NO);
    }]
    reduceEach:^id(RACTuple *arguments) {
        return arguments.first;
    }];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (scrollView.contentOffset.y < 0.0f) return;

    CGFloat min = 0.0f;
    CGFloat max = scrollView.contentSize.height - CGRectGetHeight(scrollView.bounds);

    CGPoint offset = CGPointZero;

    if (velocity.y > 0) {
        offset.y = max;
    } else if (velocity.y < 0) {
        offset.y = min;
    } else {
        offset.y = (targetContentOffset->y < max / 2)? min : max;
    }

    *targetContentOffset = offset;
}

@end

