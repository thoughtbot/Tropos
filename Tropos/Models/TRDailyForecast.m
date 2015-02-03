#import "TRDailyForecast.h"
#import "TRTemperature.h"

@interface TRDailyForecast ()

@property (nonatomic, readwrite) NSDate *date;
@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, readwrite) TRTemperature *highTemperature;
@property (nonatomic, readwrite) TRTemperature *lowTemperature;

@end

@implementation TRDailyForecast

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];
    if (!self) return nil;

    self.date = [NSDate dateWithTimeIntervalSince1970:[JSON[@"time"] doubleValue]];
    self.conditionsDescription = JSON[@"icon"];
    self.highTemperature = [TRTemperature temperatureFromFahrenheit:JSON[@"temperatureMax"]];
    self.lowTemperature = [TRTemperature temperatureFromFahrenheit:JSON[@"temperatureMin"]];

    return self;
}

@end
