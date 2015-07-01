#import "TRDailyForecastViewModel.h"
#import "Tropos-Swift.h"
#import "TRTemperatureFormatter.h"

@interface TRDailyForecastViewModel ()

@property (nonatomic) DailyForecast *dailyForecast;
@property (nonatomic) TRTemperatureFormatter *temperatureFormatter;

@end

@implementation TRDailyForecastViewModel

- (instancetype)initWithDailyForecast:(DailyForecast *)dailyForecast
{
    self = [super init];
    if (!self) return nil;

    self.dailyForecast = dailyForecast;

    return self;
}

#pragma mark - API

- (NSString *)dayOfWeek
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"ccc";
    return [dateFormatter stringFromDate:self.dailyForecast.date];
}

- (UIImage *)conditionsImage
{
    return [UIImage imageNamed:self.dailyForecast.conditionsDescription];
}

- (NSString *)highTemperature
{
    return [[TRTemperatureFormatter new] stringFromTemperature:self.dailyForecast.highTemperature];
}

- (NSString *)lowTemperature
{
    return [[TRTemperatureFormatter new] stringFromTemperature:self.dailyForecast.lowTemperature];
}

@end
