@import CoreLocation;
#import "TRWeatherUpdate.h"
#import "TRTemperature.h"

@interface TRWeatherUpdate ()

@property (nonatomic, copy, readwrite) NSString *city;
@property (nonatomic, copy, readwrite) NSString *state;
@property (nonatomic, copy, readwrite) NSString *conditionsDescription;
@property (nonatomic, readwrite) TRTemperature *currentTemperature;
@property (nonatomic, readwrite) TRTemperature *currentLow;
@property (nonatomic, readwrite) TRTemperature *currentHigh;
@property (nonatomic, readwrite) TRTemperature *yesterdaysTemperature;
@property (nonatomic, readwrite) CGFloat windSpeed;
@property (nonatomic, readwrite) CGFloat windBearing;
@property (nonatomic, readwrite) NSDate *date;

@end

@implementation TRWeatherUpdate

- (instancetype)initWithPlacemark:(CLPlacemark *)placemark currentConditionsJSON:(id)currentConditionsJSON yesterdaysConditionsJSON:(id)yesterdaysConditionsJSON
{
    self = [super init];
    if (!self) return nil;

    self.city = placemark.locality;
    self.state = placemark.administrativeArea;

    NSDictionary *todaysConditions = currentConditionsJSON[@"currently"];
    NSDictionary *yesterdaysConditions = yesterdaysConditionsJSON[@"currently"];
    NSDictionary *todaysForecast = [currentConditionsJSON[@"daily"][@"data"] firstObject];

    self.conditionsDescription = todaysConditions[@"icon"];
    self.currentTemperature = [TRTemperature temperatureFromFahrenheit:todaysConditions[@"temperature"]];
    self.currentLow = [TRTemperature temperatureFromFahrenheit:todaysForecast[@"temperatureMin"]];
    self.currentHigh = [TRTemperature temperatureFromFahrenheit:todaysForecast[@"temperatureMax"]];
    self.yesterdaysTemperature = [TRTemperature temperatureFromFahrenheit:yesterdaysConditions[@"temperature"]];
    self.windBearing = [todaysConditions[@"windBearing"] floatValue];
    self.windSpeed = [todaysConditions[@"windSpeed"] floatValue];
    self.date = [NSDate date];
    
    return self;
}

@end
